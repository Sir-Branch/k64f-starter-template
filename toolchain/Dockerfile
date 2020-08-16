FROM ubuntu:18.04

ARG USER_USERNAME
ARG USER_UID
ARG USER_GID

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

USER root

RUN apt-get -y update && \
    apt-get install -y apt-utils && \
    apt-get install -y build-essential cmake unzip wget python python-pip git && \
    apt-get clean

WORKDIR /tmp

RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 && \
    tar -xvf gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 && \
    mv gcc-arm-none-eabi-8-2018-q4-major /opt/arm-none-eabi-gcc && \
    rm gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 && \
    rm -rf /tmp/*

RUN pip install nrfutil

COPY files/nRF-Command-Line-Tools_10_7_0_Linux-amd64.deb /tmp
RUN dpkg -i /tmp/nRF-Command-Line-Tools_10_7_0_Linux-amd64.deb

RUN groupadd -g ${USER_GID} ${USER_USERNAME} && \
    useradd -r -u ${USER_UID} -g ${USER_USERNAME} ${USER_USERNAME} && \
    mkdir -p /home/${USER_USERNAME}    
COPY files/bashrc.sh /home/${USER_USERNAME}/.bashrc    
RUN chown ${USER_USERNAME}:${USER_USERNAME} -R /home/${USER_USERNAME} 

RUN mkdir /external && chmod 777 -R /external
WORKDIR /external

USER ${USER_USERNAME}

CMD ["/bin/bash"]