# make sure zprofile gets sourced, as for some reason it doesn't sometimes
# but only do it once so that if ```source ~/.zshrc``` is called we don't add paths again
[[ -v ZPROFILE_SOURCED ]] || source "$HOME/.zprofile" && export ZPROFILE_SOURCED=true

# Path to config folder if not already set
[[ -v ZSH_CONFIG ]] || export ZSH_CONFIG="$HOME/.zsh-config"

# source zplug
[[ -r $ZSH_CONFIG/zplug.zshrc ]] && source $ZSH_CONFIG/zplug.zshrc

# Changes the command execution timestamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
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
[[ -v DEFAULT_USER_SETUP ]] || DEFAULT_USER="$(whoami)" && DEFAULT_USER_SETUP=yes

# set NVM location unless already set
[[ -v NVM_LOCATION ]] || NVM_LOCATION="$HOME/.nvm"

# set version of nvm to use, only if it's not set
# because this is set, assuming that nvm is used nowhere in zshrc's, it can be redefined locally to switch the version (in ~/.zsh_local)
# without having to affect the version saved in git
## commented out, set locally if needed
#if [ -z ${NVM_USE_VERSION+x} ]; then
#    NVM_USE_VERSION="4.5.0"
#fi

# see if nvm is installed
if [[ -r $NVM_LOCATION/nvm.sh ]]; then
    # if it is, define a function to load it when needed, home do it when needed because it takes forever
    if ! type nvm &> /dev/null ; then
	    function nvm() {
            source  "$NVM_LOCATION/nvm.sh"
            [[ -v NVM_USE_VERSION ]] && nvm use "v$NVM_USE_VERSION" 1> /dev/null
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

[[ -r $ZSH_CONFIG/aliases.zshrc  ]] && source $ZSH_CONFIG/aliases.zshrc

[[ -r $ZSH_CONFIG/functions.zshrc  ]] && source $ZSH_CONFIG/functions.zshrc

[[ -r $ZSH_CONFIG/arch-settings.zshrc ]] && source $ZSH_CONFIG/arch-settings.zshrc

[[ -r $ZSH_CONFIG/debian-settings.zshrc ]] && source $ZSH_CONFIG/debian-settings.zshrc

[[ -r $ZSH_CONFIG/wine.zshrc ]] && type wine &>/dev/null && source $ZSH_CONFIG/wine.zshrc

[[ -r $ZSH_CONFIG/youtube-dl.zshrc ]] && type youtube-dl &>/dev/null && source $ZSH_CONFIG/youtube-dl.zshrc

[[ -r $HOME/.zsh-local.zshrc ]] && source ~/.zsh-local.zshrc
