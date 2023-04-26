#!/bin/bash

cd /etc/yum.repos.d/
sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

sudo dnf -y install epel-release
sudo dnf -y install fuse git cmake mesa-libGL-devel gcc gcc-c++ automake cmake pulseaudio-libs-devel gtk3-devel freeglut freeglut-devel libusb1-devel libtool fftw-devel libarchive wget

sudo bash -c "echo /usr/local/lib64/ > /etc/ld.so.conf.d/CubicSDR.el8_3.x86_64.conf"

