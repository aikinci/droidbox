# https://github.com/aikinci/droidbox
# A dockerized Droidbox instance
FROM ubuntu:latest
MAINTAINER ali@ikinci.info

WORKDIR /opt

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:$JAVA_HOME/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV ROOTPASSWORD droidbox
# fastdroid-vnc was taken from https://code.google.com/p/fastdroid-vnc/ it is GPLv2 licensed
ADD fastdroid-vnc /build/
ADD install-fastdroid-vnc.sh /build/
ADD run.sh /build/
ADD droidbox.py.patch /build/

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends openjdk-7-jre-headless apt-utils expect curl wget  git openssh-server libc6:i386 libncurses5:i386 libstdc++6:i386 bsdmainutils patch && \

    curl -L https://raw.github.com/embarkmobile/android-sdk-installer/version-2/android-sdk-installer | bash /dev/stdin --dir=/opt --install=platform-tool,system-image,android-16 && \
    rm -f /opt/android-sdk_r24.3.3-linux.tgz /opt/android-sdk-linux/system-images/android-16/default/armeabi-v7a/ramdisk.img /opt/android-sdk-linux/system-images/android-16/default/armeabi-v7a/system.img && \

    android create avd -n droidbox -t 1 -d 2 && \

    curl -O http://droidbox.googlecode.com/files/DroidBox411RC.tar.gz && \
    tar xfz DroidBox411RC.tar.gz && \
    rm -f DroidBox411RC.tar.gz && \

    # ssh setup
    sed  's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config -i && \
    echo "root:$ROOTPASSWORD" | chpasswd && \

    /build/install-fastdroid-vnc.sh && \
    cd /opt/DroidBox_4.1.1/scripts && patch < /build/droidbox.py.patch && \

    rm -rfv /var/lib/apt/lists/* && \
    apt-get -y remove \
    	    expect \
	    patch \
	    git \
	    wget \
	    curl && \
    apt-get clean && apt-get autoclean && \
    apt-get -y autoremove && \
    dpkg -l |grep ^rc |awk '{print $2}' |xargs dpkg --purge

CMD ["NONE"]

ENTRYPOINT ["/build/run.sh"]
