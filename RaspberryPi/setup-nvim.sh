#!/bin/bash

set -e

# check if .config/nvim exists
if [ ! -d "$HOME/.config" ]; then
    echo "creating .config directory"
    mkdir -p $HOME/.config
fi

# force copy Nvim to .config/nvim
echo "copying Nvim to .config/nvim"
if [ -d "$HOME/.config/nvim" ]; then
    rm -rf $HOME/.config/nvim
fi
cp -r Nvim/* $HOME/.config/nvim/

cd $HOME

echo "cloning neovim"
if [ ! -d "neovim" ]; then
    git clone https://github.com/neovim/neovim
fi
cd neovim
if [ -d "build" ]; then
    echo "removing build directory"
    sudo rm -rf build
fi

echo "checking out nightly"
git checkout nightly       

echo "pulling latest neovim"
git pull origin nightly

echo "building neovim"
mkdir build

echo "building neovim"
# Check if there's a previous installation to uninstall
if [ -f "build/CMakeCache.txt" ] || [ -d "build/CMakeFiles" ]; then
    echo "uninstalling previous build"
    sudo cmake --build build/ --target uninstall || echo "no previous installation found"
else
    echo "no previous build cache found, skipping uninstall"
fi

echo "building neovim"
make CMAKE_BUILD_TYPE=Release

echo "installing neovim"
cd build && sudo cpack -G DEB && sudo dpkg -i --force-overwrite nvim-linux*.deb

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
