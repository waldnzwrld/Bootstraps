#!/bin/bash

set -e

# use -w to set the wallet address, NAME will always be the hostname
while getopts w: flag
do
    WALLET_ADDRESS=${OPTARG}
done

# Check if wallet address was provided
if [ -z "$WALLET_ADDRESS" ]; then
    echo "Error: Wallet address is required. Use -w flag to specify wallet address."
    echo "Usage: $0 -w <wallet_address>"
    exit 1
fi

NAME=$(hostname)

echo "Installing dependencies"
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

echo "Cloning xmrig"
git clone https://github.com/MoneroOcean/xmrig

echo "Building xmrig"
mkdir -p xmrig/build
cd xmrig/build
cmake ..
make

echo "Moving xmrig to /usr/local/bin"
sudo mv xmrig /usr/local/bin/
echo "Setting up xmrig config"
sed -i "s/DEFAULT_WALLET_ADDRESS/$WALLET_ADDRESS/g" ../../.xmrig.json
sed -i "s/DEFAULT_NAME/$NAME/g" ../../.xmrig.json
sudo mv ../../.xmrig.json /usr/local/bin/config.json
sudo ln -s /usr/local/bin/config.json /home/$(whoami)/.xmrig.json

# add a crontab entry to run xmrig on reboot
echo "Setting up crontab entry"
(crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/xmrig") | crontab -

echo "adding stats to .zshrc"
echo 'echo "XMRIG RUNNING AT PID $(pgrep xmrig)"' >> /home/$(whoami)/.zshrc
echo 'echo "current stats"' >> /home/$(whoami)/.zshrc
echo "curl -s \"https://api.moneroocean.stream/miner/$WALLET_ADDRESS/stats/$NAME\"" >> /home/$(whoami)/.zshrc

echo "Cleaning up"
cd ..
rm -rf xmrig

echo "Done"