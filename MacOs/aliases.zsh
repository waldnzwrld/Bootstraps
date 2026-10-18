alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload=". ~/.zshrc"
alias vim=$(which nvim)
alias python="python3"
alias pip="pip3"
alias cd="z"
alias ,m="y"
alias ,gg="lazygit"
alias n="nvim ."
alias updates="brew update && brew upgrade && brew cleanup && npm update -g && ya pkg upgrade && nvim --headless '+lua vim.pack.update(nil, { force = true })' +qa && nvim --headless -c 'luafile ~/.config/nvim/scripts/mason-update.lua' && mas upgrade"
alias reloadvcv="pkill Rack && open -a /Applications/VCV*"
alias bmake="bear -- make"
alias argo="kubectl port-forward -n argocd svc/argocd-server 8080:443"
alias second-line-staging-db="kubectl port-forward -n second-line-staging svc/second-line-postgres 5433:5432"
alias journal="outl --workspace ~/Documents/Journal/"
alias llama="llama-server -hf unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q4_K_M --jinja -c 65536 -fa auto --cache-type-k q8_0 --cache-type-v q8_0 -ngl 99 --host 127.0.0.1 --port 8080"
alias listerine="ssh waldnzwrld@192.168.1.142"
alias claude="caveman claude"

kicad() {
    local dir="${1:-.}"
    open -a KiCad "$dir"/*.kicad_pro
}
vcvhelper() {
  # If no arguments or help flag, run without arguments
  if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    python "$RACK_DIR"/helper.py
  else
    # Set second argument to "." if not specified
    local dir="${3:-.}"
    python "$RACK_DIR"/helper.py "$1" "$2" "$dir"
  fi
}

remove_quarantine() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: remove_quarantine <file1> [file2 ...]"
    return 1
  fi
  xattr -c "$1"
}
