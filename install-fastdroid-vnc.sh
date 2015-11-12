#!/bin/sh
emulator64-arm @droidbox -no-window -no-audio -system /opt/DroidBox_4.1.1/images/system.img -ramdisk /opt/DroidBox_4.1.1/images/ramdisk.img &
sleep 5
adb wait-for-device && adb push /build/fastdroid-vnc /data && adb shell chmod 755 /data/fastdroid-vnc 
adb shell reboot -p
