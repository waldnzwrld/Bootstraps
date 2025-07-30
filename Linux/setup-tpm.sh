#!/bin/bash

set -e

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.config/tmux

cp ../tmux.conf ~/config/tmux/tmux.conf

