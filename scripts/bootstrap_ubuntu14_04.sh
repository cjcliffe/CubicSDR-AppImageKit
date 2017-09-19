#!/bin/bash

sudo sed -i -e 's|main|main universe|g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y install git cmake libgl1-mesa-dev build-essential automake cmake libpulse-dev libgtk-3-dev freeglut3 freeglut3-dev libusb-1.0-0-dev libtool texinfo libfftw-dev

#AppImageKit doesn't like dash
#In a throwaway VM this shouldn't be a problem
sudo rm /bin/sh
sudo ln -s /bin/bash /bin/sh
