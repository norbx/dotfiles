export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git)

zstyle ':omz:update' mode auto      # update automatically without asking

source $ZSH/oh-my-zsh.sh

# Global configuration
ZSH_CUSTOM=$HOME/my_customizations

alias gck='git checkout'
alias gs='git status'