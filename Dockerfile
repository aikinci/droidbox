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

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y dist-upgrade 
RUN apt-get install -y --no-install-recommends openjdk-7-jdk apt-utils curl expect python-tk python-matplotlib nano git openssh-server telnet libc6:i386 libncurses5:i386 libstdc++6:i386 bsdmainutils

RUN curl -O http://dl.google.com/android/android-sdk_r22.6.2-linux.tgz 
RUN tar xfz android-sdk_r22.6.2-linux.tgz

RUN curl -O http://droidbox.googlecode.com/files/DroidBox411RC.tar.gz
RUN tar xfz DroidBox411RC.tar.gz

RUN rm -f android-sdk_r22.6.2-linux.tgz DroidBox411RC.tar.gz

ADD accept-licenses /build/
RUN expect /build/accept-licenses "android update sdk --no-ui --all --filter platform-tool,system-image,android-16" "android-sdk-license-bcbbd656"
RUN echo "\n"| android create avd -n droidbox -t 1 -d 2

# ssh setup
RUN sed  's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config  -i
RUN echo "root:$ROOTPASSWORD" | chpasswd

# fastdroid-vnc was taken from https://code.google.com/p/fastdroid-vnc/ it is GPLv2 licensed
ADD fastdroid-vnc /build/
ADD install-fastdroid-vnc /build/
RUN /build/install-fastdroid-vnc
ADD run /build/

CMD ["NONE"]

ENTRYPOINT ["/build/run"]
