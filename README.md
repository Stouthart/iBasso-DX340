<img src="https://ibasso.com/wp-content/uploads/2024/12/2024-12-24469.webp" />

<h3>iBasso DX340 Performance Tweaks (no rooting required)</h3>

<i>Work in progres...</i>

Download and install <a href="https://developer.android.com/tools/releases/platform-tools" target="_blank">SDK Platform tools</a>. On your device, make sure WiFi is turned on and enable USB debugging.

From a Command prompt, or Terminal window on Mac, run the following commands:
<pre>
adb root
adb remount
adb shell
</pre>
From the DX340 prompt, run:
<pre>
curl -fs https://raw.githubusercontent.com/Stouthart/iBasso-DX340/refs/heads/main/tweak.sh | /bin/sh 
</pre>

Your device will reboot automatically.

Note: adb remount may take 15-30 secs on 1st run, you can safely ignore any output.

Undoing is just as easy:
<pre>
adb root
adb remount
adb shell unlink /etc/init/custom.rc
adb shell unlink /etc/rc.local
adb reboot
</pre>

Enjoy the improvements!
