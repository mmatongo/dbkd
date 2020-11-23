# zsh dir
export ZSH="/home/dm/.oh-my-zsh"

# zsh source
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi

# random exports

export TYPEWRITTEN_MULTILINE=true
export TYPEWRITTEN_CURSOR="beam"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# chroot exports
export PATH="$HOME/.local/share/junest/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export CABALDIR="$HOME/.local/bin/:$PATH"

# .config dir
. /home/dm/.profile
# export XDG_CONFIG_HOME=$HOME/.config/
# export XDG_CONFIG_DIRS=/home/dm/.sx

# auto-start x
[ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ] && exec sx

# LANG exports
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 
. /home/dm/dm/toledo/toledo
. /home/dm/.dotbare/dotbare.plugin.zsh

# aliases
. /home/dm/dots/aliases

# others
export PF_INFO="ascii os kernel uptime pkgs memory"

# tmux var
#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  exec tmux
#fi

#if [[ $DISPLAY ]]; then
#    # If not running interactively, do not do anything
#    [[ $- != *i* ]] && return
#    [ -n "$PS1" ]
#    [[ -z "$TMUX" ]] && exec tmux
#fi
