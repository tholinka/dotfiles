# switch vi and vim to neovim if it exists
if type nvim &> /dev/null ; then
    alias vi="nvim"
    alias vim="nvim"

    # also switch various other utilities
    alias edit="nvim"
    alias vedit="nvim"
    alias ex="nvim -E"
    alias view="nvim -R"
# switch vi and other utilities to vim if neovim doesn't exist
elif type vim &> /dev/null ; then
    alias vi="vim"
    alias edit="vim"
    alias vedit="vim"
    alias ex="vim -E"
    alias view="nvim -R"

    alias rvim="vim -Z"
    alias evim="vim -y"
fi

# switch ls to exa if it exists, set it as a variable so that I can alias it with colors later
if type exa &> /dev/null ; then
    ls="exa"
else
    ls="ls"
fi

alias ls="$ls"

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
#alias pgrep="pgrep $COL_OPT"
alias xzgrep="xzgrep $COL_OPT"
alias zegrep="zegrep $COL_OPT"
alias zfgrep="zfgrep $COL_OPT"
alias zgrep="zgrep $COL_OPT"
alias zipgrep="zipgrep $COL_OPT"

alias dmesg="sudo dmesg $COL_OPT"
alias fdisk="sudo fdisk $COL_OPT"

# we set options for diff later, so don't alias it
diff="diff $COL_OPT"

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
alias glances="glances -t 5 --disable-check-update"

# set resolution to 1080p, mostly useful in vms
alias fixres="xrandr --newmode \"1920x1080\"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync && xrandr --addmode Virtual1 1920x1080 && xrandr --output Virtual1 --mode 1920x1080"

# set diff default settings
alias diff="$diff --unified=0"

alias c="clear"
alias get="git"
alias gitk="gitk &>/dev/null & "
alias gitgui="git gui &>/dev/null &"
alias gitupdatesubmodules="git submodule update --jobs $(nproc --all) --recursive --remote"

# random fortune, outputed using cowsay and rainbow if present
if type fortune &>/dev/null; then
    FORTCOMMAND="fortune"

    # is cowsay installed?
    if type cowsay &>/dev/null; then
        # what directory are cows in?
        COWSAYCOWS="/usr/share/cowsay/cows"
        if [ ! -d "$COWSAYCOWS" ]; then
            # arch has it setup this way
            COWSAYCOWS="/usr/share/cows"
        fi

        # did we find the cows directory?
        if [ -d "$COWSAYCOWS" ]; then
            # \$ls so that it doesn't resolve at source time, but at run time
            FORTCOMMAND="$FORTCOMMAND | cowsay -f \$(ls $COWSAYCOWS | shuf -n1)"
        else
            FORTCOMMAND="$FORTCOMMAND | cowsay"
        fi
    fi

    # is lolcat installed?
    if type lolcat &>/dev/null; then
        FORTCOMMAND="$FORTCOMMAND | lolcat"
    fi

    alias fortune="$FORTCOMMAND"
fi

# semi-useful upgrade function for debian based distros
if type "apt" &> /dev/null ; then
    alias aptupdateall="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y"
fi
