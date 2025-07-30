#!/bin/bash

set -e

cp -r ../yazi $HOME/.config/yazi

echo "compiling rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "source ~/.cargo/env" >> ~/.zshrc

source $HOME/.cargo/env

rustup update

cd $HOME

echo "downloading yazi"
git clone https://github.com/sxyazi/yazi.git
cd yazi

echo "compiling yazi"
cargo build --release --locked

sudo mv target/release/yazi target/release/ya /usr/local/bin

echo "installing yazi packages and config"
cd $HOME
curl https://install.duckdb.org | sh
sudo mv $HOME/.duckdb/cli/latest/duckdb /usr/local/bin/duckdb

source $HOME/.zshrc
ya pkg install
ya pkg upgrade

echo "cleaning up"
cd $HOME
sudo rm -rf yazi
sudo rm -rf .duckdb
