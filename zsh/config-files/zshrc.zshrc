# make sure zprofile gets sourced, as for some reason it doesn't sometimes, but only do it once so that if ```source ~/.zshrc``` is called we don't add paths again
if [ -z ${ZPROFILE_SOURCED+x} ]; then
    source "$HOME/.zprofile"
    export ZPROFILE_SOURCED=true
fi

# Path to config folder if not already set
if [ -z ${ZSH_CONFIG+x} ]; then
  export ZSH_CONFIG="$HOME/.zsh-config"
fi

# source zplug
if [ -f $ZSH_CONFIG/zplug.zshrc  ]; then
  source $ZSH_CONFIG/zplug.zshrc
fi

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# set editor to vim for git / etc
export EDITOR=vim
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# Compilation flags
export ARCHFLAGS="-arch $(uname --machine)"
export USE_CCACHE=1
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

# set up default user for theme, done in two sed steps to also work for root (home is /root on arch)
if [ -z ${DEFAULT_USER_SETUP+x} ]; then
  DEFAULT_USER="$(whoami)"
  DEFAULT_USER_SETUP=yes
fi

# get NVM location unless already set
if [ -z ${NVM_LOCATION+x} ]; then
    NVM_LOCATION="$HOME/.nvm"
fi

# set version of nvm to use, only if it's not set
# because this is set, assuming that nvm is used nowhere in zshrc's, it can be redefined locally to switch the version (in ~/.zsh_local)
# without having to affect the version saved in git
if [ -z ${NVM_USE_VERSION+x} ]; then
    NVM_USE_VERSION="4.5.0"
fi

# see if nvm is installed
if [ -f "$NVM_LOCATION/nvm.sh" ]; then
    # if it is, define a function to load it when needed, home do it when needed because it takes forever
    if ! type "nvm" &> /dev/null ; then
	    function nvm() {
		    source  $NVM_LOCATION/nvm.sh

            nvm use "v$NVM_USE_VERSION" 1> /dev/null
		    nvm "$@"
	    }
    fi
fi

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

if [ -f $ZSH_CONFIG/aliases.zshrc  ]; then
  source $ZSH_CONFIG/aliases.zshrc
fi

if [ -f $ZSH_CONFIG/functions.zshrc  ]; then
  source $ZSH_CONFIG/functions.zshrc
fi

if [ -f $ZSH_CONFIG/arch-settings.zshrc ]; then
  source $ZSH_CONFIG/arch-settings.zshrc
fi

if [ -f $ZSH_CONFIG/debian-settings.zshrc ]; then
    source $ZSH_CONFIG/debian-settings.zshrc
fi

if [ -f $ZSH_CONFIG/wine.zshrc ] && type wine &>/dev/null; then
  source $ZSH_CONFIG/wine.zshrc
fi

if [ -f $ZSH_CONFIG/youtube-dl.zshrc ] && type youtube-dl &>/dev/null; then
  source $ZSH_CONFIG/youtube-dl.zshrc
fi

if [ -f ~/.zsh-local.zshrc ]; then
  source ~/.zsh-local.zshrc
fi