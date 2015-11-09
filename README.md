droidbox
========

A dockerized [DroidBox][1] instance

Get it from the [Honeynet Project's Docker Repository][2]

Sourcecode is on [Ali Ikinci's GitHub][3]

This is a ready to run Android sandbox enabling the user to run a dynamic analysis on an apk file. Create a ~/samples directory and copy you sample file in it.

Usage: With readonly sample protection (recomended)

    docker run -it --rm -v ~/samples:/samples:ro -v ~/samples/out:/samples/out honeynet/droidbox /samples/filename.apk [duration in seconds]

Usage: Without readonly sample protection

    docker run -it --rm -v ~/samples:/samples honeynet/droidbox /samples/filename.apk [duration in seconds]

VNC access:

This instance comes with a preinstalled VNC server allowing you to view and modify the emulator during the run. You have to forward the VNC port to your local host in order to connect you VNC client. SSH password is "droidbox"

    ssh -L 5900:localhost:5900 root@$(cat ~/samples/ip.txt)

ADB access:

You can also forward Port 5554 and 5555 to connect to the emulator and use adb for further instrumentation and analysis.

    ssh -L 5556:localhost:5554 -L 5557:localhost:5555 root@$(cat ~/samples/ip.txt)
    adb kill-server
    adb shell

Check out a sample screencast:

[![asciicast](https://asciinema.org/a/11019.png)](https://asciinema.org/a/11019)

Additional features:

* Takes a screenshot every 5 seconds

  [1]: https://github.com/pjlantz/droidbox
  [2]: https://hub.docker.com/r/honeynet/droidbox/
  [3]: https://github.com/aikinci/droidbox
