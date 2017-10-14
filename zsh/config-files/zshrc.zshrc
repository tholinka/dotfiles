# make sure zprofile gets sourced, as for some reason it doesn't sometimes
source "$ZSH_CONFIG/zprofile.zshrc"

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
export ARCHFLAGS="-arch x86_64"
export USE_CCACHE=1
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

# only load nvm when we absolutly have to because it takes forever
if ! type "nvm" &> /dev/null ; then
	function nvm() {
		source  ~/.nvm/nvm.sh
		nvm use v4.5.0 1> /dev/null
		nvm "$@"
	}
fi

if [ -f $ZSH_CONFIG/zsh-aliases.zshrc  ]; then
  source $ZSH_CONFIG/zsh-aliases.zshrc
fi

if [ -f $ZSH_CONFIG/zsh-functions.zshrc  ]; then
  source $ZSH_CONFIG/zsh-functions.zshrc
fi

if [ -f ~/.zsh_local.zshrc ]; then
  source ~/.zsh_local.zshrc
fi
