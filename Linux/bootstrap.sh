#!/bin/bash
#

set -e
sudo apt-get update
xargs -a ../packages.txt sudo apt-get install

# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# copy the connect_to_wifi script to /usr/local/bin
sudo cp connect_to_wifi.sh /usr/local/bin/connect_to_wifi

# copy the aliases.zsh file to the ~/.oh-my-zsh/custom/aliases.zsh file
cp aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

# copy the zshrc file
cp .zshrc ~/.zshrc

./setup-yazi

#
./setup-nvim.sh
