#!/bin/bash

if [ ${EUID} -ne 0 ]; then
  echo "Please run this script again using 'sudo'!"
  exit 1
fi

apt-get remove docker docker-engine docker.io
apt-get update
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce

groupadd docker
usermod -aG docker $USER

read -p "We need to reboot your computer to let the magic dust settle on the microchips. Can we do it now? [Y/N] " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    reboot
fi