#!/bin/zsh

export TERM=xterm-256color
export PATH="$PATH:/usr/local/sbin"
export CLICOLOR=1
export DOTFILES="$HOME/dotfiles"

# TODO SPLIT THESE OUT

# init antibody
source <(antibody init)

antibody bundle < $DOTFILES/bundles

# setup
export ZSH_CUSTOM=~/.zsh
setopt PROMPT_SUBST

# borrowed from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/git.zsh
# to make spaceship work
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# spaceship config
SPACESHIP_PROMPT_SYMBOL=➔
SPACESHIP_PROMPT_ORDER=(
  time          # Time stampts section
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  venv          # virtualenv section
  pyenv         # Pyenv section
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  char          # Prompt character
)

# aliases
alias reload="exec zsh"

# history
SAVEHIST=1000
HISTFILE="$HOME/.zhistory"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt histignorealldups


# add color
autoload colors
colors
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"


# completion
# is this right?????
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# auto cd
setopt auto_cd
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
zstyle ':completion:*:cd:*' ignore-parents parent pwd


# things that run when we open a shell
neofetch --config "${DOTFILES}/neofetch/config"
fortune
