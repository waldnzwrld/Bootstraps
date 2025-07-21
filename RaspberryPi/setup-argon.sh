#!/bin/bash

set -e

echo "Installing dependencies"
curl https://download.argon40.com/argon-eeprom.sh | bash
curl https://download.argon40.com/argon1.sh | bash

echo "Setting up argon config"
sudo mv .argon.config /etc/argoneoned.conf
sudo ln -s /etc/argoneoned.conf /home/$(whoami)/.argon.config

echo "Done"

