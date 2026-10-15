alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload=". ~/.zshrc"
alias vim=$(which nvim)
alias python="python3"
alias pip="pip3"
alias cd="z"
alias ,m="y"
alias n="nvim ."
alias updates="ya pkg upgrade && nvim --headless '+lua vim.pack.update(nil, { force = true })' +qa && nvim --headless -c 'luafile ~/.config/nvim/scripts/mason-update.lua'"
