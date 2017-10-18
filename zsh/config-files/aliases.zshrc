# switch vi and vim to nvim if it exists
if type nvim &> /dev/null ; then
    alias vi="nvim"
    alias vim="nvim"
fi

# switch ls to exa if it exists, set it as a variable so that I can alias it with colors later
ls="ls"
if type exa &> /dev/null ; then
    ls="exa"
fi
alias ls="$LS"

# set colors
COL_OPT="--color=always"
## dircolors
if [ -x dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

## ls options that are the same for ls and exa, set to always use color
alias ls="$ls $COL_OPT --group-directories-first"

## add color support to a bunch of commands
alias dir="dir $COL_OPT"
alias vdir="vdir $COL_OPT"

## there are to many different greps
alias bzgrep="bzgrep $COL_OPT"
alias egrep="egrep $COL_OPT"
alias fgrep="fgrep $COL_OPT"
alias grep="grep $COL_OPT"
alias pgrep="pgrep $COL_OPT"
alias xzgrep="xzgrep $COL_OPT"
alias zegrep="zegrep $COL_OPT"
alias zfgrep="zfgrep $COL_OPT"
alias zgrep="zgrep $COL_OPT"
alias zipgrep="zipgrep $COL_OPT"

alias dmesg="sudo dmesg $COL_OPT"
alias fdisk="sudo fdisk $COL_OPT"
alias diff="diff $COL_OPT"
alias top="top -c"


# color man through "hacking" less
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

# color less
export LESS='-R'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# color gcc
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -a'
alias l='ls -F'

alias fdiskl="fdisk -l"

# make iotop easier to use
alias iotop="sudo iotop -Pao"
# add default glances stuff
alias glances="glances -t 5"

# set resolution to 1080p, mostly useful in vms
alias fixres="xrandr --newmode \"1920x1080\"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync && xrandr --addmode Virtual1 1920x1080 && xrandr --output Virtual1 --mode 1920x1080"

# set diff default settings
alias diff="$diff --unified=0"

alias c="clear"
alias get="git"
alias gitk="gitk &>/dev/null & "
alias gitgui="git gui &>/dev/null &"
alias gitupdatesubmodules="git submodule update --recursive --remote"

# semi-useful upgrade function for debian based distros
if type "apt" &> /dev/null ; then
    alias aptupdateall="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y"
fi

# switch to colormake if it's present
if type "colormake" &> /dev/null ; then
    # also set j for ease of use
    alias make='colormake -j$(nproc --all)'

    alias gcc='COLORMAKE_COMMAND=gcc colormake'
    alias clang='COLORMAKE_COMMAND=clang colormake'
fi