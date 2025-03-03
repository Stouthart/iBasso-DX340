#!/bin/sh

# v1.0, Copyright (c) 2025, Stouthart. All rights reserved.

# Check preconditions
failed() { printf '\e[31mFailed: %s\e[m\n' "$1"; exit 1; }
[ "$(whoami)" != root ] && failed 'Root privileges required. Did you run adb root?'
! touch /etc/init/custom.rc 2>/dev/null && failed 'Read-only file system. Did you run adb remount?'

echo 'Running...'


## https://android.stackexchange.com/questions/217495/how-can-proc-sys-values-be-changed-at-boot-sysctl-conf-does-this-on-normal-lin
## https://android.googlesource.com/platform/system/core/+/master/init/README.md

cat >/etc/init/custom.rc <<EOF
on init
  write /sys/kernel/debug/debug_enabled N

  ## https://github.com/redhat-performance/tuned/tree/master/profiles
  write /proc/sys/kernel/timer_migration 0
  write /proc/sys/net/core/somaxconn 2048
  write /proc/sys/net/ipv4/tcp_fastopen 3
  write /proc/sys/vm/dirty_background_ratio 3
  write /proc/sys/vm/dirty_ratio 10
  write /proc/sys/vm/stat_interval 10

on late-init
  # Disable scheduler statistics to reduce overhead (enabled in /etc/init/atrace.rc) 
  write /proc/sys/kernel/sched_schedstats 0

on late-fs
  ## https://source.android.com/docs/core/perf/boot-times#tuning-the-filesystem
  write /sys/block/sda/queue/iostats 0
  write /sys/block/sda/queue/read_ahead_kb 2048

on property:sys.boot_completed=1
  # Runtime SchedTune
  write /dev/stune/schedtune.boost 10
  write /dev/stune/foreground/schedtune.boost 15
  write /dev/stune/foreground/schedtune.prefer_idle 1
  write /dev/stune/top-app/schedtune.boost 25
  write /dev/stune/top-app/schedtune.prefer_idle 1

  # Fork & execute /etc/rc.local
  exec_background -- /etc/rc.local
EOF

chmod 0644 /etc/init/custom.rc
chcon u:object_r:system_file:s0 /etc/init/custom.rc


cat >/etc/rc.local <<EOF
#!${SHELL}

sleep 10

# Runtime TuneD
echo 10 >/proc/sys/vm/swappiness

## https://github.com/LeanxModulostk/IRQ-Balancer-Configuration/blob/main/service.sh
renice -n -10 -p "\$(pidof msm_irqbalance)"

# Move android.hardware.audio.service to top-app cpuset
pidof android.hardware.audio.service >/dev/stune/top-app/tasks

# Disable IPv6
echo 1 >/proc/sys/net/ipv6/conf/all/disable_ipv6

# SD card tuning (if found)
[ -f /sys/block/mmcblk0/queue/iostats ] && echo 0 >/sys/block/mmcblk0/queue/iostats

exit 0

EOF

chmod +x /etc/rc.local


echo 'Rebooting...'
reboot

exit 0
