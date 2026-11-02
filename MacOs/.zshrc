# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export XDG_CONFIG_HOME=$HOME/.config
export RBENV=$HOME/.rbenv/shims
export GOPATH=`go env GOPATH`
export GOBIN=$GOPATH/bin
export CARGO=$HOME/.cargo/bin
# Python should reference the executable installed by homebrew, which is used by pyenv to manage Python versions. This ensures that when you switch Python versions with pyenv, the correct Python executable is used.
export PYTHON=$(brew --prefix)/opt/python/bin
export PATH=$RBENV:$GOBIN:$CARGO:$PYTHON:$PATH

 #Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export RACK_DIR="$HOME/Code/Rack-SDK"
 #Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, 
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="muse"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(brew colored-man-pages gh git golang jsontools)
export EDITOR="nvim"

source $ZSH/oh-my-zsh.sh
source "/opt/homebrew/opt/spaceship/spaceship.zsh"
source "$HOME/.config/yazi/cd-on-quit"
source $ZSH_CUSTOM/aliases.zsh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# For a full list of active aliases, run `alias`.
#
eval "$(zoxide init zsh)"
