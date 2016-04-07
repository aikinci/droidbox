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
ENV sv=r24.4.1
# fastdroid-vnc was taken from https://code.google.com/p/fastdroid-vnc/ it is GPLv2 licensed
ADD fastdroid-vnc /build/
ADD install-fastdroid-vnc.sh /build/
ADD run.sh /build/
ADD droidbox.py.patch /build/

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends python-tk python-matplotlib openjdk-7-jre-headless apt-utils expect curl wget  git openssh-server libc6:i386 libncurses5:i386 libstdc++6:i386 bsdmainutils patch && \
    curl -L https://raw.github.com/aikinci/android-sdk-installer/master/android-sdk-installer |sed 's/android-sdk-license-5be876d5/android-sdk-license-c81a61d9/'|bash /dev/stdin --dir=/opt --install=platform-tools,,android-16 && \
    curl -L https://raw.github.com/aikinci/android-sdk-installer/master/android-sdk-installer |sed 's/wget/#wget/' |sed 's/tar/#tar/' | bash /dev/stdin --dir=/opt --install=system-image,android-16 && \
    android create avd -n droidbox -t 1 -d 7 && \
    rm -fv /opt/android-sdk_$sv-linux.tgz /opt/android-sdk-linux/system-images/android-16/default/armeabi-v7a/ramdisk.img /opt/android-sdk-linux/system-images/android-16/default/armeabi-v7a/system.img && \
    curl -LO https://github.com/pjlantz/droidbox/releases/download/v4.1.1/DroidBox411RC.tar.gz && \
    tar xfz DroidBox411RC.tar.gz && \
    rm -f DroidBox411RC.tar.gz && \

    # ssh setup
    sed  's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config -i && \
    echo "root:$ROOTPASSWORD" | chpasswd && \

    /build/install-fastdroid-vnc.sh && \
    cd /opt/DroidBox_4.1.1/scripts && patch < /build/droidbox.py.patch && \

    rm -rfv /var/lib/apt/lists/* && \
    apt-get -y remove \
	    curl \
	    git \
	    patch \
	    wget \
    	expect && \
    apt-get clean && apt-get autoclean && \
    apt-get -y autoremove && \
    dpkg -l |grep ^rc |awk '{print $2}' |xargs dpkg --purge

EXPOSE 5901 5554 5555

CMD ["NONE"]

ENTRYPOINT ["/build/run.sh"]
