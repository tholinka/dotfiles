# assume we're not using nvim
USE_NVIM="false"
# see if nvim is installed, if it is, make sure it's new enough, or fallback to it if vim is to old
if type nvim &> /dev/null ; then
	version="$( nvim --version | head -n1 | sed 's/NVIM v//' )"
	# 0.3.0 <= $version && use nvim || use vim
	verlte 0.3.0 "$version" && USE_NVIM="true" || USE_NVIM="false"

	if [ "USE_NVIM" = "false" ]; then
		# but only use that if regular vim is greater than v8
		version="$( vim --version | head -n1 | sed 's/VIM - Vi IMproved //' | sed -r 's/ \(.+//' )"
		verlte 8.0 "$version" && USE_NVIM="false" || USE_NVIM="true"
	fi
fi

if [ "$USE_NVIM" = "true" ]; then
	alias vi="nvim"
    alias vim="nvim"

    # also switch various other utilities
    alias edit="nvim"
    alias vedit="nvim"
    alias ex="nvim -E"
    alias view="nvim -R"
	# switch $EDITOR
	EDITOR="nvim"
# switch vi and other utilities to vim if neovim doesn't exist
elif [ "$USE_NVIM" = "false" ] && type vim &> /dev/null ; then
    alias vi="vim"
    alias edit="vim"
    alias vedit="vim"
    alias ex="vim -E"
	# switch $EDITOR to vim
	EDITOR="vim"
elif type vi &> /dev/null; then
	# make sure editor gets setup
	EDITOR="vi"
fi

unset USE_NVIM

# switch the other editor variables
SUDO_EDITOR="$EDITOR"
VISUAL="$EDITOR"
GIT_EDITOR="$EDITOR"

# switch ls to exa if it exists, set it as a variable so that I can alias it with colors later
if type exa &> /dev/null ; then
    ls="exa"
else
    ls="ls"
fi

alias ls="$ls"

# set colors
COLOR_OPT="--color=always"

## ls options that are the same for ls and exa, set to always use color
alias ls="$ls $COLOR_OPT --group-directories-first"

## add color support to a bunch of commands
alias dir="dir $COLOR_OPT"
alias vdir="vdir $COLOR_OPT"

## there are to many different greps
alias bzgrep="bzgrep $COLOR_OPT"
alias egrep="egrep $COLOR_OPT"
alias fgrep="fgrep $COLOR_OPT"
alias grep="grep $COLOR_OPT"
#alias pgrep="pgrep $COLOR_OPT"
alias xzgrep="xzgrep $COLOR_OPT"
alias zegrep="zegrep $COLOR_OPT"
alias zfgrep="zfgrep $COLOR_OPT"
alias zgrep="zgrep $COLOR_OPT"
alias zipgrep="zipgrep $COLOR_OPT"

alias dmesg="sudo dmesg $COLOR_OPT"
alias fdisk="sudo fdisk $COLOR_OPT"

# not all versions of diff accept colors, so figure out if this one does
# do this by specifing the color, and then request the version
# ubuntu (subsystem for windows)'s diff will return false saying unrecognized option, but arch just returns the version
# similiar to ls, set diff as a variable as it will be alias'ed later
if ! diff "$COLOR_OPT" -v &>/dev/null; then
    # doesn't support COLOR_OPT, see if colordiff is installed
    if type colordiff &>/dev/null; then
        diff="colordiff"
    else
        # no colordiff, fall back to uncolored diff
        diff="diff"
    fi
else
    # supports color opt, use it
    diff="diff $COLOR_OPT"
fi

alias top="top -c"

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
if type iotop &>/dev/null; then
	alias iotop="sudo iotop -Pao"
fi

# add default glances stuff
if type glances &>/dev/null; then
	alias glances="glances -t 5 --disable-check-update"
fi

# set resolution to 1080p, mostly useful in vms
alias fixres="xrandr --newmode \"1920x1080\"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync && xrandr --addmode Virtual1 1920x1080 && xrandr --output Virtual1 --mode 1920x1080"

# set diff default settings
alias diff="$diff --unified=0"

alias c="clear"
alias get="git"
alias gitk="gitk &>/dev/null &"
alias gitgui="git gui &>/dev/null &"
alias gitupdatesubmodules="git submodule update --jobs $(nproc --all) --recursive --remote"

alias perm="stat -c \"%a %n\""

# follow output of journalctl unit
alias journalctl-follow="journalctl -feu"

# random fortune, outputed using cowsay and rainbow if present
if type fortune &>/dev/null; then
    FORTCOMMAND="fortune"

    # is cowsay installed?
    if type cowsay &>/dev/null; then
        # what directory are cows in?
        COWSAYCOWS="/usr/share/cowsay/cows"
        if [[ ! -d $COWSAYCOWS ]]; then
            # arch has it setup this way
            COWSAYCOWS="/usr/share/cows"
        fi

        # did we find the cows directory?
        if [[ -d $COWSAYCOWS ]]; then
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
