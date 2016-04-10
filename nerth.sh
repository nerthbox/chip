#!/bin/bash

echo -e "\n Setting up environment in Ubuntu 14.04"
sudo apt-get -y update
sudo apt-get -y install \
 build-essential \
 cmake \
 unzip \
 device-tree-compiler \
 libncurses-dev \
 cu \
 linux-image-extra-virtual \
 u-boot-tools \
 android-tools-fsutils \
 python-dev \
 libusb-1.0-0-dev \
 g++-arm-linux-gnueabihf \
 pkg-config \
 libusb-1.0-0 \
 libusb-1.0-0-dbg \
 libusb-1.0-0-dev \
 screen

if uname -a |grep -q 64;
then
  echo -e "\n Installing 32bit compatibility libraries"
  sudo apt-get -y install libc6-i386 lib32stdc++6 lib32z1
fi

echo -e "\n Adding current user to dialout group"
sudo usermod -a -G dialout $(logname)

echo -e "\n Adding current user to plugdev group"
sudo usermod -a -G plugdev $(logname)


echo -e "\n Adding udev rule for Allwinner device"
echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="efe8", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip"
SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="1010", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip-fastboot"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="1010", GROUP="plugdev", MODE="0660" SYMLINK+="usb-chip-fastboot"
SUBSYSTEM=="usb", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", GROUP="plugdev", MODE="0660" SYMLINK+="usb-serial-adapter"
' | sudo tee /etc/udev/rules.d/99-allwinner.rules
sudo udevadm control --reload-rules

echo -e "\n Installing sunxi-tools"
git clone http://github.com/NextThingCo/sunxi-tools

cd sunxi-tools
make
if [[ -L /usr/local/bin/fel ]]; then
	sudo rm /usr/local/bin/fel
fi
sudo ln -s $PWD/fel /usr/local/bin/fel

cd ..

echo -e "\n Installing CHIP-tools"
git clone http://github.com/NextThingCo/CHIP-tools

echo -e "\n Installing CHIP-buildroot"
git clone http://github.com/NextThingCo/CHIP-buildroot

