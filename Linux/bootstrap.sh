#!/bin/bash
#

# symlink the connect_to_wifi script to /usr/local/bin
sudo ln -sf connect_to_wifi.sh /usr/local/bin/connect_to_wifi

# symlink the aliases.zsh file to the ~/.oh-my-zsh/custom/aliases.zsh file
sudo ln -sf aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

# symlink the zshrc file
sudo ln -sf .zshrc ~/.zshrc

# symlink yazi
sudo ln -sf ../yazi ~/.config/yazi

#symlink neovim
sudo ln -sf ../nvim ~/.config/nvim

# symlink ghostty
sudo ln -sf ../ghostty ~/.config/ghostty

# symlink lazygit
sudo ln -sf ../lazygit ~/.config/lazygit


sudo mv /etc/apt/preferences.d/nosnap.pref /etc/apt/preferences.d/nosnap.pref.disabled | true

sudo install -d -m 0755 /etc/apt/keyrings
sudo curl -fsSL https://downloads.claude.ai/keys/claude-code.asc \
  -o /etc/apt/keyrings/claude-code.asc
echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/stable stable main" | sudo tee /etc/apt/sources.list.d/claude-code.list


echo "setting up yazi"
curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null

set -e
sudo apt-get update
xargs -a ../packages.txt sudo apt-get install -y

sudo snap install nvim --classic
sudo snap install vivaldi --classic
sudo snap install ghostty --classic

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

# install rust and tree-sitter-cli
curl https://sh.rustup.rs -sSf | sh
export PATH=$HOME/.cargo/bin:$PATH
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo binstall tree-sitter-cli

# swap keys to mac layout
setxkbmap -option altwin:swap_alt_win


