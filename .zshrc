export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/dotfiles/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

plugins=(git colorize)

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
EDITOR="code --wait"

source $ZSH/oh-my-zsh.sh

## autocompletion
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

## zsh history
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

setopt hist_ignore_all_dups 
setopt hist_reduce_blanks 
setopt inc_append_history 
setopt share_history 

setopt correct_all

setopt auto_list 
setopt auto_menu 
setopt always_to_end

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completio
zstyle ':omz:update' mode auto      # update automatically without asking

# Global config
eval "$(direnv hook zsh)"

# Global configuration
alias gs='git status'
