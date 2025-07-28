#!/bin/bash

set -e

# check if .config/nvim exists
if [ ! -d "$HOME/.config" ]; then
    echo "creating .config directory"
    mkdir -p $HOME/.config
fi

# force copy Nvim to .config/nvim
echo "copying Nvim to .config/nvim"
cp -r Nvim $HOME/.config/nvim

cd $HOME

echo "cloning neovim"
if [ ! -d "neovim" ]; then
    git clone https://github.com/neovim/neovim
fi
cd neovim
if [ -d "build" ]; then
    echo "removing build directory"
    rm -rf build
fi

echo "pulling latest neovim"
git pull

echo "building neovim"
mkdir build

echo "building neovim"
sudo cmake --build build/ --target uninstall

echo "checking out nightly"
git checkout nightly

echo "building neovim"
make CMAKE_BUILD_TYPE=Release

echo "installing neovim"
cd build && sudo cpack -G DEB && sudo dpkg -i --force-overwrite nvim-linux-arm64.deb

echo "checking neovim version"
nvim -V1 -v

echo "installing plugins"
nvim --headless -c "PlugInstall" -c "qa"

echo "copying PluginConf to .config/nvim/init.lua"
cd $HOME/.config/nvim
cat ./PluginConf >> init.lua

echo "removing neovim directory"
cd $HOME
rm -rf neovim

echo "done"
