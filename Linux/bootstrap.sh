#!/bin/bash
#

# symlink the connect_to_wifi script to /usr/local/bin
sudo ln -sf connect_to_wifi.sh /usr/local/bin/connect_to_wifi

# symlink the aliases.zsh file to the ~/.oh-my-zsh/custom/aliases.zsh file
ln -sf aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

# symlink the zshrc file
ln -sf .zshrc ~/.zshrc

# symlink yazi
ln -sf ../yazi ~/.config/yazi

#symlink neovim
ln -sf ../nvim ~/.config/nvim

# symlink ghostty
ln -sf ../ghostty ~/.config/ghostty

# symlink lazygit
ln -sf ../lazygit ~/.config/lazygit

set -e
sudo apt-get update
xargs -a ../packages.txt sudo apt-get install -y

echo "setting up lazygit"
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') 
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit 
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit*

# install oh my zsh 
if [ ! -d ~/.oh-my-zsh ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

