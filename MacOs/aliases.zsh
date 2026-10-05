alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload=". ~/.zshrc"
alias vim=$(which nvim)
alias python="python3"
alias pip="pip3"
alias cd="z"
alias ,m="y"
alias n="nvim ."
alias updates="brew update && brew upgrade && brew cleanup && ya pkg upgrade"
alias cursor="cursor-agent"
alias pr="gh pr create --fill"
alias lg="lazygit"
alias notes="outl --workspace ~/Documents/notes"
alias gal="gcloud auth login"
alias crd="carto_remote_dev"

remove_quarantine() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: remove_quarantine <file1> [file2 ...]"
    return 1
  fi
  xattr -c "$1"
}
