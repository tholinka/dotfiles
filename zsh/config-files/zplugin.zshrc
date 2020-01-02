# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

# zplugin, when using the module, can cause issues if sourced twice, so don't allow that
# also, if there ARE issues, delete the *.zwc files in ~/.zsh-config
if (( $+functions[zplugin] )); then
	return;
fi


LOCAL_PLUGINS="$ZSH_CONFIG/local-plugins"

# init zplugin
# use module if avilable
_ZPLUGIN_MODULE_PATH="$ZSH_CONFIG/zplugin/zmodules/Src"
if [[ -r "$_ZPLUGIN_MODULE_PATH/zdharma/zplugin.so" ]]; then
	module_path+=( "$_ZPLUGIN_MODULE_PATH" )
	zmodload zdharma/zplugin
	_ZPLUGIN_USING_MODULE=yes
fi
# this is copied directly from install.sh for zplugin
source "$ZSH_CONFIG/zplugin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
#end install.sh section from zplugin

#_ZLM, to allow global switch between load and light
#_ZLM=load
_ZLM=light

# Load these things immediatly
_ZPLUGIN_WAIT=0
# we construct this in a way that the values of the variables are ran at run time, so we can change the "wait" on the fly
alias _ZPLUGIN_DEFAULT_ICE='zplugin ice lucid depth"1" from"github"'
alias _ZPLUGIN_DEFAULT_ICE_WAIT="g_ZPLUGIN_DEFAULT_ICE wait\"$_ZPLUGIN_WAIT\""
# only use svn if its present
(( $+commands[svn] )) && _ZPLUGIN_USE_SVN="yes"

if [[ -v _ZPLUGIN_USE_SVN ]]; then
	alias _ZPLUGIN_SNIPPET_DEFAULT_ICE="zplugin ice lucid svn wait\"$_ZPLUGIN_WAIT\""
else
	alias _ZPLUGIN_SNIPPET_DEFAULT_ICE="zplugin ice lucid wait\"$_ZPLUGIN_WAIT\""
fi

# oh-my-zsh plugins
_ZPLUGIN_SNIPPET_DEFAULT_ICE
if [[ -v _ZPLUGIN_USE_SVN ]]; then
	zplugin snippet OMZ::"plugins/colorize"
else
	zplugin snippet OMZ::"plugins/colorize/colorize.plugin.zsh"
fi


### Theme note: if there is a "wait" present, it will fail to load on first prompt
### and will instead load after a command is entered
## Get theme from my fork
#_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "tholinka/agnoster-zsh-theme"
## Powerlevel10k
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM romkatv/powerlevel10k

_ZPLUGIN_WAIT=1
alias _ZPLUGIN_DEFAULT_ICE_WAIT="_ZPLUGIN_DEFAULT_ICE wait\"$_ZPLUGIN_WAIT\""
# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#_ZPLUGIN_DEFAULT_ICE_WAIT;zplugin $_ZLM "tombh/zsh-git-prompt" # my theme handles this
## don't run anything pasted until I manually hit enter key
_ZPLUGIN_DEFAULT_ICE_WAIT; zplugin $_ZLM "oz/safe-paste"
## additional zsh completions
_ZPLUGIN_DEFAULT_ICE_WAIT; zplugin $_ZLM "zsh-users/zsh-completions"
## substring history search (type partial history and arrow key up/down to search history)
_ZPLUGIN_DEFAULT_ICE_WAIT; zplugin $_ZLM "zsh-users/zsh-history-substring-search"
## command suggestions
_ZPLUGIN_DEFAULT_ICE_WAIT; zplugin $_ZLM "zsh-users/zsh-autosuggestions"
## syntax highlighting
_ZPLUGIN_DEFAULT_ICE_WAIT; zplugin $_ZLM "zdharma/fast-syntax-highlighting"
## 256color
#ZSH_256COLOR_DEBUG=true
_ZPLUGIN_DEFAULT_ICE_WAIT; zplugin $_ZLM "chrissicool/zsh-256color"

## automatically change terminal title based on location / task
_ZPLUGIN_DEFAULT_ICE_WAIT; zplugin $_ZLM "jreese/zsh-titles"
# note: if these fail to clone, try running the ice and load manually
# Only load these if the relevent program is installed
## adds clipboard helper functions to pipe into/out of clipboard
_ZPLUGIN_DEFAULT_ICE_WAIT if"(( $+commands[xclip] ))"; zplugin $_ZLM "zpm-zsh/clipboard"
## docker autocmplete
_ZPLUGIN_DEFAULT_ICE_WAIT if"(( $+commands[docker] ))" pick"contrib/completion/zsh/_docker"
zplugin $_ZLM "docker/cli"
## git
_ZPLUGIN_SNIPPET_DEFAULT_ICE if"(( $+commands[git] ))"
if [[ -v _ZPLUGIN_USE_SVN ]]; then
	zplugin snippet OMZ::"plugins/git"
else
	zplugin snippet OMZ::"plugins/git/git.plugin.zsh"
fi
## git flow
_ZPLUGIN_DEFAULT_ICE_WAIT if"git flow version &>/dev/null"
zplugin $_ZLM "petervanderdoes/git-flow-completion"
## fuzzy search
### executable
#### try to decode which version to get
_FZF_ARCH="$(uname -m)"
if [[ $_FZF_ARCH == "x86_64" ]]; then
	_FZF_ARCH="amd64"
# arch rpi2
elif [[ $_FZF_ARCH == "armv7l" ]]; then
	_FZF_ARCH="arm7"
fi
_FZF_MACHINE="$(uname)"
# set default to linux
_FZF_MACHINE="${_FZF_MACHINE:=linux}"
# to lower case
_FZF_MACHINE="$_FZF_MACHINE:l"
### actually try install
zplugin ice lucid wait"$_ZPLUGIN_WAIT" from"gh-r" as"program" bpick"*$_FZF_MACHINE*$_FZF_ARCH*" if"! (( $+commands[fzf] ))"
zplugin $_ZLM junegunn/fzf-bin
### zsh support
_ZPLUGIN_DEFAULT_ICE_WAIT pick"shell/*.zsh"
zplugin $_ZLM "junegunn/fzf"
### set up FZF
#export FZF_COMPLETION_TRIGGER="tt"
## python virtual environment
_ZPLUGIN_DEFAULT_ICE_WAIT if"(( $+commands[python3] ))"
zplugin $_ZLM "MichaelAquilina/zsh-autoswitch-virtualenv"
### setup venv
export AUTOSWITCH_DEFAULT_PYTHON="/usr/bin/python3"

autoload -Uz compinit
compinit
