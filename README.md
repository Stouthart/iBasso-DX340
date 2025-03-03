<h3>iBasso DX340 Performance Tweaks</h3>

Work in progres...

Download & install <a href="https://developer.android.com/tools/releases/platform-tools">SDK Platform tools/ADB</a>. Make sure WiFi is turned on and enable USB debugging.

From a Command prompt, or Terminal window on Mac, run the following commands:
<pre>
adb root
adb remount
adb shell
</pre>
From the DX340 prompt, run:
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
