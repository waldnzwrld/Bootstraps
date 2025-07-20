#!/bin/bash

set -e

echo "installing dependencies"
sudo apt install zsh thefuck -y

echo "setting up ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "setting up zshrc"
sed -i "s/robbyrussell/pygmalion/g" ~/.zshrc
sed -i "s/plugins=(git)/plugins=(colored-man-pages colorize debian git thefuck)/g" ~/.zshrc

echo "setting up zsh plugins"
sed -i "s/plugins=(git)/plugins=(colored-man-pages colorize debian git thefuck)/g" ~/.zshrc

echo "setting up oh-my-zsh as ssh shell"
echo 'if [[ -n $SSH_CONNECTION ]] ; then
        zsh
fi' >> ~/.bashrc

echo "Done"

