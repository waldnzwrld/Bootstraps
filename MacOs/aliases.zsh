alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload=". ~/.zshrc"
alias vim=$(which nvim)
alias python="python3"
alias pip="pip3"
alias cd="z"
alias ls="y"
alias updates="brew update && brew upgrade && brew cleanup && mas upgrade"
kicad() {
    local dir="${1:-.}"
    open -a KiCad "$dir"/*.kicad_pro
}
