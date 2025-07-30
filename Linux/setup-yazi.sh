#!/bin/bash

set -e

cp ../yazi $HOME/.config/yazi

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

source ~/.zshrc
ya pkg install
ya pkg upgrade

curl https://install.duckdb.org | sh

sudo mv $HOME/.duckdb/cli/latest/duckdb /usr/local/bin/duckdb

source ~/.zshrc

sudo rm -rf $HOME/.duckdb
