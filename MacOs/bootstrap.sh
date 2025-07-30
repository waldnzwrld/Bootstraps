#!/bin/bash

set -e

# if homebrew is not installed install it
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# if this fails keep going
brew bundle --file=Brewfile.common || true

# ask if this is a personal or professional build
read -p "Is this a personal or business build? (p/b) " build_type

if [ "$build_type" == "p" ]; then
    brew bundle --file=Brewfile.personal || true
else
    brew bundle --file=Brewfile.professional || true
fi

# copy the aliases.zsh file to the ~/.oh-my-zsh/custom/aliases.zsh file
cp aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

# copy the zshrc file
cp .zshrc ~/.zshrc

cp ../yazi ~/.config/yazi
ya pkg install
ya pkg upgrade

cp ../nvim ~/.config/nvim

nvim --headless -c "PlugInstall" -c "qa"

echo "copying PluginConf to .config/nvim/init.lua"
cd ~/.config/nvim
cat ./PluginConf >> init.lua
