#!/bin/bash

set -e


echo "setting up ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cp .zshrc ~/.zshrc
cp aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
cp ../nnn-quitcd.sh ~/.config/nnn/plugins/quitcd.sh
cp ../Linux/connect_to_wifi.sh /usr/local/bin/connect_to_wifi.sh

echo "setting up oh-my-zsh as ssh shell"
echo 'if [[ -n $SSH_CONNECTION ]] ; then
        zsh
fi' >> ~/.bashrc

echo "Done"

