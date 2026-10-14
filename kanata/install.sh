#!/bin/bash
#
# Install kanata and run it as a systemd user service on Debian (apt) or
# Arch (pacman). Safe to re-run.
#
# Root steps (each echoed before it runs):
#   - kanata binary (built with cargo) into /usr/local/bin
#   - /etc/udev/rules.d/99-kanata.rules so the input group can open /dev/uinput
#   - /etc/modules-load.d/uinput.conf so the uinput module loads at boot
#   - add $USER to the input group
#   - enable lingering so kanata starts at boot, before login

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
. "$REPO_ROOT/Linux/pkg.sh"

# Same as link() in Linux/bootstrap.sh.
link() {
    local src="$1" dest="$2" runner="${3:-}"
    $runner rm -rf "$dest"
    $runner mkdir -p "$(dirname "$dest")"
    $runner ln -sfn "$src" "$dest"
}

echo "kanata: installing watcher/resume dependencies"
if [ "$PKG_MGR" = apt ]; then
    pkg_install jq libglib2.0-bin
else
    pkg_install jq glib2
fi

echo "kanata: building with cargo"
export PATH="$HOME/.cargo/bin:$PATH"
if ! command -v cargo >/dev/null 2>&1; then
    curl https://sh.rustup.rs -sSf | sh -s -- -y
fi
cargo install kanata --locked
echo "kanata: [sudo] installing binary to /usr/local/bin"
sudo install -m 0755 "$HOME/.cargo/bin/kanata" /usr/local/bin/kanata

echo "kanata: [sudo] writing udev rule for /dev/uinput"
echo 'KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"' \
    | sudo tee /etc/udev/rules.d/99-kanata.rules >/dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "kanata: [sudo] loading uinput at boot"
echo uinput | sudo tee /etc/modules-load.d/uinput.conf >/dev/null
sudo modprobe uinput

NEW_GROUP=0
if ! id -nG "$USER" | grep -qw input; then
    echo "kanata: [sudo] adding $USER to the input group"
    sudo usermod -aG input "$USER"
    NEW_GROUP=1
fi

echo "kanata: [sudo] enabling lingering for $USER"
sudo loginctl enable-linger "$USER"

# config and user units
link "$SCRIPT_DIR" ~/.config/kanata
for unit in "$SCRIPT_DIR"/systemd/*.service; do
    link "$unit" ~/.config/systemd/user/"$(basename "$unit")"
done

systemctl --user daemon-reload
# kanata-watch has no [Install]; sway starts it once WAYLAND_DISPLAY is set.
systemctl --user enable kanata.service kanata-resume.service

if [ "$NEW_GROUP" = 1 ]; then
    echo "kanata: log out and back in (or reboot) for the input group to apply, then:"
    echo "  systemctl --user start kanata.service kanata-resume.service"
else
    systemctl --user restart kanata.service kanata-resume.service
fi
