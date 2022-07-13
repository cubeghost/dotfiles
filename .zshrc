#!/bin/zsh

export CLICOLOR=1
export DOTFILES="$HOME/dotfiles"
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=10000

# New shell stuff.
neofetch --config "${DOTFILES}/neofetch/config"
fortune

# Based on https://github.com/romkatv/zsh-bench/blob/master/configs/diy%2B%2Bfsyh/skel/.zshrc

function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# Clone and compile to wordcode missing plugins.
if [[ ! -e ~/fast-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/fast-syntax-highlighting
  mv -- ~/fast-syntax-highlighting/{'→chroma','tmp'}
  zcompile-many ~/fast-syntax-highlighting/{fast*,.fast*,**/*.ch,**/*.zsh}
  mv -- ~/fast-syntax-highlighting/{'tmp','→chroma'}
fi
if [[ ! -e ~/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/zsh-autosuggestions
  zcompile-many ~/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -e ~/zsh-history-substring-search ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git ~/zsh-history-substring-search
  zcompile-many ~/zsh-history-substring-search/*.zsh
fi
if [[ ! -e ~/zsh-titles ]]; then
  git clone --depth=1 https://github.com/jreese/zsh-titles.git ~/zsh-titles
  zcompile-many ~/zsh-titles/*.zsh
fi
if [[ ! -e ~/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  make -C ~/powerlevel10k pkg
fi

# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable the "new" completion system (compsys).
autoload -Uz compinit && compinit
[[ ~/.zcompdump.zwc -nt ~/.zcompdump ]] || zcompile-many ~/.zcompdump
unfunction zcompile-many

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Load plugins.
source ~/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh
source ~/zsh-titles/titles.plugin.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
source $DOTFILES/.p10k.zsh

# Customize p10k prompt
POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION="➜"
POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION="➜"