droidbox
========

A dockerized DroidBox https://code.google.com/p/droidbox/ instance. 
Get it from the Docker Hub https://registry.hub.docker.com/u/riker2000/droidbox/
Sourcecode is on GitHub https://github.com/aikinci/droidbox

This is a ready to run Android sandbox enabling the user to run a dynamic analysis on an apk file.

Usage: 

    docker run -it --rm -v ~/samples:/samples riker2000/droidbox filename.apk [duration in seconds]

VNC access:

This instance comes with a preinstalled VNC server allowing you to view and modify the emulator during the run. You have to forward the VNC port to your local host in order to connect you VNC client.

    ssh -L 5900:localhost:5900 root@$(cat ~/samples/ip.txt)

ADB access:

You can also forward Port 5554 and 5555 to connect to the emulator and use adb for further instrumentation and analysis.

    ssh -L 5556:localhost:5554 -L 5557:localhost:5555 root@$(cat ~/samples/ip.txt)
    adb kill-server
    adb shell
