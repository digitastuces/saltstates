# ~/.bashrc: executed by bash(1) for non-login shells.

RED="\e[0;31m"
BRED="\e[1;31m"
GREY="\e[0;30m"
GREEN="\e[0;32m"
BGREEN="\e[0;32m"
WHITE="\e[0;37m"
YELLOW="\e[0;33m"
BYELLOW="\e[1;33m"
RST="\e[0;0m"
UNDERLINE="\e[4;37m"
BOLD="\e[1;37m"

PS1="[\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)$RST]$BGREEN::$CUSTNAME$BGREEN::$RST~>[$BRED\u$RST@$BYELLOW\h$RST:\w]                                         \n\$ > "

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -la'
alias l='ls $LS_OPTIONS -lA'
alias lll='ls -hal'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias reboot="echo Please use the full path command, but are you really sure about that ?"
alias shutdown="echo Please use the full path command, but are you really sure about that ?"
alias halt="echo Please use the full path command, but are you really sure about that ?"
