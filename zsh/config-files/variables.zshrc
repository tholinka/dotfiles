# Changes the command execution timestamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="yyyy-mm-dd"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Compilation flags
export ARCHFLAGS="-arch $(uname --machine)"
export USE_CCACHE=1
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

# set up gpg
export GPG_TTY=$(tty)

# set up devkitpro location if not already set
if [ -z ${DEVKITPRO+x} ]; then
	export DEVKITPRO="/opt/devkitpro"
fi

# set up devkitARCH variables
export DEVKITARM="$DEVKITPRO/devkitARM"
export DEVKITPPC="$DEVKITPPC/devkitPPC"
export DEVKITA64="$DEVKITPRO/devkitA64"

# set up default user for theme, done in two sed steps to also work for root (home is /root on arch)
[[ -v DEFAULT_USER_SETUP ]] || export DEFAULT_USER="$(whoami)" && DEFAULT_USER_SETUP=yes
