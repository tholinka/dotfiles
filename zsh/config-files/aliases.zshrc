# prioritise nvim if installed
if (( $+commands[nvim] )); then
	EDITOR="nvim"
# fallback to vim, if it's installed
elif (( $+commands[vim] )); then
	EDITOR="vim"
# fallback to vi, if installed
elif (( $+commands[vi] )); then
	EDITOR="vi"
# fallback to nano, if installed
elif (( $+commands[nano] )); then
	EDITOR="nano"
fi

# set commands to editor
alias vi="$EDITOR"
alias vim="$EDITOR"
# also switch various other utilities
alias edit="$EDITOR"
alias vedit="$EDITOR"
alias ex="$EDITOR -E"
alias view="$EDITOR -R"
# switch the other editor variables
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export EDITOR="$EDITOR"

# switch ls to exa if it exists, set it as a variable so that I can alias it with colors later
(( $+commands[exa] )) && ls="exa" || ls="ls"

alias ls="$ls"

# set colors
COLOR_OPT="--color=always"

# if first argument exists as a command, it sets an alias of the first argument to the value of the third argument, first argument, COLOR_OPT, second argument
# if $1 exists, sets $1 equal to $ $1 $2 $3
function color_if_installed() {
	(( $+commands[$1] )) && alias $1="$3 $1 $COLOR_OPT $2"
}

## ls options that are the same for ls and exa, set to always use color
color_if_installed ls --group-directories-first

## add color support to a bunch of commands
color_if_installed dir
color_if_installed vdir

## there are to many different greps
color_if_installed bzgrep
color_if_installed egrep
color_if_installed fgrep
color_if_installed grep
#color_if_installed pgrep
color_if_installed xzgrep
color_if_installed zegrep
color_if_installed zfgrep
color_if_installed zgrep
color_if_installed zipgrep

color_if_installed dmesg "" sudo
color_if_installed fdisk "" sudo

# not all versions of diff accept colors, so figure out if this one does
# do this by specifing the color, and then request the version
# ubuntu (subsystem for windows)'s diff will return false saying unrecognized option, but arch just returns the version
# similiar to ls, set diff as a variable as it will be alias'ed later
if ! diff "$COLOR_OPT" -v &>/dev/null; then
	# doesn't support COLOR_OPT, see if colordiff is installed
    if (( $+commands[colordiff] )); then
		diff="colordiff"
	else
		# no colordiff, fall back to uncolored diff
		diff="diff"
	fi
else
	# supports color opt, use it
	diff="diff $COLOR_OPT"
fi

# set diff default settings
alias diff="$diff --unified=0"

COLOR_OPT="-c"
color_if_installed top

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
(( $+commands[iotop] )) && alias iotop="sudo iotop -Pao"

# add default glances stuff
(( $+commands[glances] )) && alias glances="glances -t 5 --disable-check-update"

# set resolution to 1080p, mostly useful in vms
alias fixres="xrandr --newmode \"1920x1080\"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync && xrandr --addmode Virtual1 1920x1080 && xrandr --output Virtual1 --mode 1920x1080"

alias c="clear"

# list numeric perms off specified files
(( $+commands[stat] )) && alias perm="stat -c \"%a %n\""

# follow output of journalctl unit
(( $+commands[journalctl] )) && alias journalctl-follow="journalctl -feu"

# use make flags by default
alias make="make \$MAKEFLAGS"

# rsync flags
alias rsync="rsync --archive --verbose --compress --human-readable --progress --stats --sparse --partial --append-verify"

# dd show progress
alias dd="sudo dd status=progress bs=4M"
