#!/bin/bash

set -e

user=$(whoami)
dir=$(pwd)

sudo apt-get update
xargs -a ./packages.txt sudo apt-get install

echo "setting up neovim"
../Linux/setup-nvim.sh
cd $dir

sudo cp ../Linux/connect_to_wifi.sh /usr/local/bin/connect_to_wifi

echo "setting up shell"
./setup-shell.sh

# ask if we are using an argon case
read -p "Are you using an argon case? (y/n) " argon
if [ "$argon" == "y" ]; then
    echo "setting up argon"
    ./setup-argon.sh
fi

# ask if we are using a pironman case
read -p "Are you using a pironman case? (y/n) " pironman 
if [ "$pironman" == "y" ]; then
    echo "setting up pironman"
    ./setup-pironman.sh
fi

read -p "do you want to mine monero? (y/n) " monero
if [ "$monero" == "y" ]; then
    # ask for wallet address
    read -p "Enter your monero wallet address: " wallet
    echo "setting up xmrig"
    ./setup-xmrig.sh -w $wallet
    cd $dir
fi

read -p "do you want to setup kodi? (y/n) " kodi
if [ "$kodi" == "y" ]; then
    echo "setting up kodi"
    ./setup-kodi.sh
fi

read -p "do you want to setup retropie? (y/n) " retropie
if [ "$retropie" == "y" ]; then
    echo "setting up retropie"
    ./setup-retropie.sh
    cd $dir
    read -p "do you want to setup retropie-kodi? (y/n) " retropie_kodi
    if [ "$retropie_kodi" == "y" ]; then
        echo "setting up retropie-kodi"
        ./setup-retropie-kodi.sh
    fi
fi


echo "Done"
