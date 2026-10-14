#!/bin/bash
#
# Package-manager helpers shared by the Linux and RaspberryPi installers.
# Source this file; it sets PKG_MGR to "apt" (Debian/Ubuntu/Raspberry Pi OS)
# or "pacman" (Arch and derivatives) and exits if neither is found.
#
# Package lists use one package per line:
#   <apt-name> [pacman-name]
# A single name is used for both. Use "-" to skip a package on that system.
# Blank lines and "#" comments are ignored.

detect_pkg_manager() {
    local id="" id_like=""
    if [ -r /etc/os-release ]; then
        id="$(. /etc/os-release && echo "${ID:-}")"
        id_like="$(. /etc/os-release && echo "${ID_LIKE:-}")"
    fi

    case " $id $id_like " in
        *" arch "*) PKG_MGR=pacman ;;
        *" debian "* | *" ubuntu "*) PKG_MGR=apt ;;
        *)
            if command -v pacman >/dev/null 2>&1; then
                PKG_MGR=pacman
            elif command -v apt-get >/dev/null 2>&1; then
                PKG_MGR=apt
            else
                echo "Unsupported distro: need apt (Debian) or pacman (Arch)" >&2
                exit 1
            fi
            ;;
    esac
    export PKG_MGR
}

# Refresh package metadata. On Arch this is a full upgrade, since syncing the
# database without upgrading (pacman -Sy) leads to partial-upgrade breakage.
pkg_update() {
    case "$PKG_MGR" in
        apt) sudo apt-get update ;;
        pacman) sudo pacman -Syu --noconfirm ;;
    esac
}

# Install packages by their native names for the current package manager.
pkg_install() {
    [ "$#" -gt 0 ] || return 0
    case "$PKG_MGR" in
        apt) sudo apt-get install -y "$@" ;;
        pacman) sudo pacman -S --needed --noconfirm "$@" ;;
    esac
}

# Print the native package names from a two-column package list.
pkg_resolve_list() {
    local apt_name pacman_name name
    while read -r apt_name pacman_name _; do
        case "$apt_name" in "" | \#*) continue ;; esac
        if [ "$PKG_MGR" = pacman ]; then
            name="${pacman_name:-$apt_name}"
        else
            name="$apt_name"
        fi
        [ "$name" = "-" ] || echo "$name"
    done <"$1"
}

# Install every package in a two-column package list.
pkg_install_list() {
    local pkgs
    mapfile -t pkgs < <(pkg_resolve_list "$1")
    pkg_install "${pkgs[@]}"
}

detect_pkg_manager
