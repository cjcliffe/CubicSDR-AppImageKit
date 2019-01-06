#!/bin/bash

sudo apt-get update
sudo apt-get -y install fuse git cmake libgl1-mesa-dev build-essential automake cmake libpulse-dev libgtk-3-dev freeglut3 freeglut3-dev libusb-1.0-0-dev libtool texinfo libfftw3-dev

if [ -d "/vagrant" ]; then
  mv /usr/bin/cmake /usr/bin/cmake-dist
  wget -q https://cmake.org/files/v3.11/cmake-3.11.1-Linux-x86_64.sh
  chmod +x cmake-3.11.1-Linux-x86_64.sh
  cd /
  vagrant/cmake-3.11.1-Linux-x86_64.sh --skip-license
fi

