#!/bin/bash

set -e

# check if .config/nvim exists
if [ ! -d "$HOME/.config" ]; then
    mkdir -p $HOME/.config
fi

# force copy Nvim to .config/nvim
cp Nvim $HOME/.config/nvim

cd $HOME

git clone https://github.com/neovim/neovim
cd neovim

sudo cmake --build build/ --target uninstall
git checkout nightly
make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i --force-overwrite nvim-linux-arm64.deb
nvim -V1 -v

nvim --headless -c "PlugInstall" -c "qa"

cd $HOME/.config/nvim

cat ./PluginConf > init.lua
