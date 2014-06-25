droidbox
========

A dockerized DroidBox https://code.google.com/p/droidbox/ instance.

This is a ready to run Android sandbox enabling the user to run a dynamic analysis on an apk file.

Usage: 

    docker run -it --rm -v ~/samples:/samples riker2000/droidbox filename.apk [duration in seconds]

Note: This instance comes with a preinstalled VNC server allowing you to view and modify the emulator during the run. You have to forward the VNC port to your local host in order to connect you VNC client.

    ssh -L 5900:localhost:5900 root@$(cat ~/samples/ip.txt)

