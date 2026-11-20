#
# ~/.bashrc
#

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec start-hyprland
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(starship init bash)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
