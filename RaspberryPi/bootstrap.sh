#!/bin/bash

set -e

user=$(whoami)
dir=$(pwd)

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

sudo apt-get update
xargs -a ./packages.txt sudo apt-get install

echo "setting up neovim"
../Linux/setup-nvim.sh
cd $dir

sudo cp ../Linux/connect_to_wifi.sh /usr/local/bin/connect_to_wifi

echo "setting up shell"
./setup-shell.sh

echo "setting up yazi"
../Linux/setup-yazi.sh

echo "setting up lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit*

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
