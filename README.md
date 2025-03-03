Work in progres...

Download & install SDK Platform tools/ADB. Make sure WiFi is on and enable USB debugging (Settings > System > Developer options).

From a Command/PowerShell prompt, or Terminal window on Mac run the following commands:
<pre>
adb root
adb remount
adb shell
</pre>
From the DX340 shell prompt, run:
<pre>
curl https://raw.githubusercontent.com/Stouthart/iBasso-DX340/refs/heads/main/tweak.sh | /bin/sh 
</pre>

Your device will reboot automatically. Note: adb remount may take 15-30 secs on 1st run, you can safely ignore any output.

Undo is equally simple:
<pre>
adb root
adb remount
adb shell unlink /etc/init/custom.rc
adb shell unlink /etc/rc.local
adb reboot
<pre>
