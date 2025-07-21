#!/bin/bash

set -e

echo "setting up pironman"

# modify the eeprom to use POWER_OFF_ON_HALT=1 without using the -e flag
sudo sed -i 's/POWER_OFF_ON_HALT=0/POWER_OFF_ON_HALT=1/' /boot/config.txt

sudo apt-get update
sudo apt-get install git -y
sudo apt-get install python3 python3-pip python3-setuptools -y

cd ~
git clone -b 1.2.15 https://github.com/sunfounder/pironman5.git --depth 1
cd ~/pironman5
sudo python3 install.py

echo "cleaning up"
cd ~
rm -rf pironman5

echo "Done"