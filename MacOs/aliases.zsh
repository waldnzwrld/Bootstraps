alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload=". ~/.zshrc"
alias vim=$(which nvim)
alias python="python3"
alias pip="pip3"
alias cd="z"
alias ,m="y"
alias n="nvim ."
alias updates="brew update && brew upgrade && brew cleanup && npm update -g && ya pkg upgrade && nvim --headless '+lua vim.pack.update(nil, { force = true })' +qa && nvim --headless -c 'luafile ~/.config/nvim/scripts/mason-update.lua' && mas upgrade"
alias claude="caveman claude"
kicad() {
    local dir="${1:-.}"
    open -a KiCad "$dir"/*.kicad_pro
}
remove_quarantine() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: remove_quarantine <file1> [file2 ...]"
    return 1
  fi
  xattr -c "$1"
}
