#!/bin/bash

set -e

# if homebrew is not installed install it
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

mkdir ~/.go
export GOPATH=~/.go

# symlink the aliases.zsh file to the ~/.oh-my-zsh/custom/aliases.zsh file
ln -sf aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh

# symlink the zshrc file
ln -sf .zshrc ~/.zshrc

ln -sf ../yazi ~/.config/yazi
ya pkg install
ya pkg upgrade

ln -sf ../nvim ~/.config/nvim
ln -sf ../ghostty ~/.config/ghostty
ln -sf ../lazygit ~/.config/lazygit

# if this fails keep going
brew bundle --file=Brewfile.common || true

mas signin --dialog waldnzwrld@gmail.com

# ask if this is a personal or professional build
read -p "Is this a personal or business build? (p/b) " build_type

if [ "$build_type" == "p" ]; then
    brew bundle --file=Brewfile.personal || true
    mas lucky DaVinci\ Resolve
else
    brew bundle --file=Brewfile.professional || true
fi

cargo install stylua
npm i -g prettier typescript typescript-language-server tsx
go install golang.org/x/tools/latest/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/gordonklaus/ineffassign@latest
go install honnef.co/go/tools/cmd/gosimple@latest
