Work in progres...

Make sure WiFi is on and enable USB debugging (Settings > System > Developer options).
Run the following commands:

adb root
adb remount
adb shell
curl https://raw.githubusercontent.com/Stouthart/iBasso-DX340/refs/heads/main/tweak.sh | /bin/sh 
