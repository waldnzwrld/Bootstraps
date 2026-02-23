alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload=". ~/.zshrc"
alias vim=$(which nvim)
alias python="python3"
alias pip="pip3"
alias cd="z"
alias ,m="y"
alias ls="y"
alias n="nvim ."
alias updates="brew update && brew upgrade && brew cleanup && mas upgrade"
alias reloadvcv="pkill Rack && open -a /Applications/VCV*"
alias bmake="bear -- make"
alias cursor="cursor-agent"
alias pr="gh pr create --fill"
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
