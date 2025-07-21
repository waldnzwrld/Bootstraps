#!/bin/bash

set -e

echo "setting up retropie"
cd ~

git clone https://github.com/RetroPie/RetroPie-Setup.git

cd RetroPie-Setup

sudo ./retropie_setup.sh

echo "Done"