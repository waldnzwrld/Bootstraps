#!/bin/bash

set -e

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "source ~/.cargo/env" >> ~/.zshrc

source $HOME/.cargo/env

rustup update

cd $HOME

git clone https://github.com/sxyazi/yazi.git
cd yazi

cargo build --release --locked

sudo mv target/release/yazi target/release/ya /usr/local/bin

cd $HOME
sudo rm -rf yazi


