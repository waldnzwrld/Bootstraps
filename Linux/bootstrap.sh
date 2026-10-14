#!/bin/bash
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Create/replace a symlink at $2 pointing to $1, no matter what currently
# sits at $2 (missing, a file, a symlink, or a real directory). Pass "sudo"
# as $3 when the destination requires root (e.g. /usr/local/bin).
link() {
    local src="$1" dest="$2" runner="${3:-}"
    $runner rm -rf "$dest"
    $runner mkdir -p "$(dirname "$dest")"
    $runner ln -sfn "$src" "$dest"
}

# symlink the connect_to_wifi script to /usr/local/bin
link "$SCRIPT_DIR/connect_to_wifi.sh" /usr/local/bin/connect_to_wifi sudo

# symlink the aliases.zsh file to the ~/.oh-my-zsh/custom/aliases.zsh file
link "$SCRIPT_DIR/aliases.zsh" ~/.oh-my-zsh/custom/aliases.zsh

# symlink the zshrc file
link "$SCRIPT_DIR/.zshrc" ~/.zshrc

# symlink yazi
link "$REPO_ROOT/yazi" ~/.config/yazi

#symlink neovim
link "$REPO_ROOT/nvim" ~/.config/nvim

# symlink ghostty
link "$REPO_ROOT/ghostty" ~/.config/ghostty

# symlink lazygit
link "$REPO_ROOT/lazygit" ~/.config/lazygit

# symlink kanata
link "$REPO_ROOT/kanata" ~/.config/kanata


. "$SCRIPT_DIR/pkg.sh"
echo "detected package manager: $PKG_MGR"

set -e

if [ "$PKG_MGR" = apt ]; then
    sudo mv /etc/apt/preferences.d/nosnap.pref /etc/apt/preferences.d/nosnap.pref.disabled 2>/dev/null || true

    echo "add claude-code to apt"
    sudo install -d -m 0755 /etc/apt/keyrings
    sudo curl -fsSL https://downloads.claude.ai/keys/claude-code.asc \
      -o /etc/apt/keyrings/claude-code.asc
    echo "deb [signed-by=/etc/apt/keyrings/claude-code.asc] https://downloads.claude.ai/claude-code/apt/stable stable main" | sudo tee /etc/apt/sources.list.d/claude-code.list

    echo "add yazi to apt"
    curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee /usr/share/keyrings/yazi-keyring.gpg >/dev/null
    echo 'deb [signed-by=/usr/share/keyrings/yazi-keyring.gpg] https://yazi-rs.github.io/builds/ stable main' | sudo tee /etc/apt/sources.list.d/yazi.list >/dev/null
fi

pkg_update
pkg_install_list "$REPO_ROOT/packages.txt"

if [ "$PKG_MGR" = apt ]; then
    sudo snap install nvim --classic
    sudo snap install vivaldi --classic
    sudo snap install ghostty --classic

    echo "setting up lazygit"
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    rm -rf lazygit*
else
    # claude-code isn't in the Arch repos; use the native installer
    if ! command -v claude >/dev/null 2>&1; then
        curl -fsSL https://claude.ai/install.sh | bash
    fi
fi

# install oh my zsh 
if [ ! -d ~/.oh-my-zsh ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# install rust (and tree-sitter-cli on Debian; Arch gets it from pacman)
curl https://sh.rustup.rs -sSf | sh
export PATH=$HOME/.cargo/bin:$PATH
if [ "$PKG_MGR" = apt ]; then
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    cargo binstall tree-sitter-cli
fi

# install kanata (keyboard remapper) and its systemd user services
"$REPO_ROOT/kanata/install.sh"

# swap keys to mac layout (X11 only)
if command -v setxkbmap >/dev/null 2>&1; then
    setxkbmap -option altwin:swap_alt_win
fi

# install yazi plugins
ya pkg install
