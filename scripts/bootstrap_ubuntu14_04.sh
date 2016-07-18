#!/bin/bash

sudo sed -i -e 's|main|main universe|g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y install git cmake libgl1-mesa-dev build-essential automake cmake libpulse-dev libgtk-3-dev freeglut3 freeglut3-dev libusb-1.0-0-dev
