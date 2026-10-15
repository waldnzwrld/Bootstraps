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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Create/replace a symlink at $2 pointing to $1, no matter what currently
# sits at $2 (missing, a file, a symlink, or a real directory).
link() {
    local src="$1" dest="$2"
    rm -rf "$dest"
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
}

# symlink the aliases.zsh file to the ~/.oh-my-zsh/custom/aliases.zsh file
link "$SCRIPT_DIR/aliases.zsh" ~/.oh-my-zsh/custom/aliases.zsh

# symlink the zshrc file
link "$SCRIPT_DIR/.zshrc" ~/.zshrc

link "$REPO_ROOT/yazi" ~/.config/yazi
ya pkg install
ya pkg upgrade

link "$REPO_ROOT/nvim" ~/.config/nvim
link "$REPO_ROOT/ghostty" ~/.config/ghostty
link "$REPO_ROOT/lazygit" ~/.config/lazygit

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
