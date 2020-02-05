# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

# zinit, when using the module, can cause issues if sourced twice, so don't allow that
# also, if there ARE issues, delete the *.zwc files in ~/.zsh-config
if (( $+functions[zinit] )); then
	return;
fi


LOCAL_PLUGINS="$ZSH_CONFIG/local-plugins"

# start zinit
# use module if avilable
_INIT_MODULE_PATH="$ZSH_CONFIG/zinit/zmodules/Src"
if [[ -r "$_ZINIT_MODULE_PATH/zdharma/zinit.so" ]]; then
	module_path+=( "$_ZINIT_MODULE_PATH" )
	zmodload zdharma/zinit
	_ZINIT_USING_MODULE=yes
fi
# this is copied directly from install.sh for zinit
source "$ZSH_CONFIG/zinit/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
#end install.sh section from zinit

#_ZLM, to allow global switch between load and light
#_ZLM=load
_ZLM=light

# Load these things immediatly
_ZINIT_WAIT=0
# we construct this in a way that the values of the variables are ran at run time, so we can change the "wait" on the fly
alias _ZINIT_DEFAULT_ICE='zinit ice lucid depth"1" from"github"'
alias _ZINIT_DEFAULT_ICE_WAIT="g_ZINIT_DEFAULT_ICE wait\"$_ZINIT_WAIT\""
# only use svn if its present
(( $+commands[svn] )) && _ZINIT_USE_SVN="yes"

if [[ -v _ZINIT_USE_SVN ]]; then
	alias _ZINIT_SNIPPET_DEFAULT_ICE="zinit ice lucid svn wait\"$_ZINIT_WAIT\""
else
	alias _ZINIT_SNIPPET_DEFAULT_ICE="zinit ice lucid wait\"$_ZINIT_WAIT\""
fi

# oh-my-zsh plugins
_ZINIT_SNIPPET_DEFAULT_ICE
if [[ -v _ZINIT_USE_SVN ]]; then
	zinit snippet OMZ::"plugins/colorize"
else
	zinit snippet OMZ::"plugins/colorize/colorize.plugin.zsh"
fi


### Theme note: if there is a "wait" present, it will fail to load on first prompt
### and will instead load after a command is entered
## Get theme from my fork
#_ZINIT_DEFAULT_ICE; zinit $_ZLM "tholinka/agnoster-zsh-theme"
## Powerlevel10k
_ZINIT_DEFAULT_ICE; zinit $_ZLM romkatv/powerlevel10k

_ZINIT_WAIT=1
alias _ZINIT_DEFAULT_ICE_WAIT="_ZINIT_DEFAULT_ICE wait\"$_ZINIT_WAIT\""
# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#_ZINIT_DEFAULT_ICE_WAIT;zinit $_ZLM "tombh/zsh-git-prompt" # my theme handles this
## don't run anything pasted until I manually hit enter key
_ZINIT_DEFAULT_ICE_WAIT; zinit $_ZLM "oz/safe-paste"
## additional zsh completions
_ZINIT_DEFAULT_ICE_WAIT; zinit $_ZLM "zsh-users/zsh-completions"
## substring history search (type partial history and arrow key up/down to search history)
_ZINIT_DEFAULT_ICE_WAIT; zinit $_ZLM "zsh-users/zsh-history-substring-search"
## command suggestions
_ZINIT_DEFAULT_ICE_WAIT; zinit $_ZLM "zsh-users/zsh-autosuggestions"
## syntax highlighting
_ZINIT_DEFAULT_ICE_WAIT; zinit $_ZLM "zdharma/fast-syntax-highlighting"
## 256color
#ZSH_256COLOR_DEBUG=true
_ZINIT_DEFAULT_ICE_WAIT; zinit $_ZLM "chrissicool/zsh-256color"

## automatically change terminal title based on location / task
_ZINIT_DEFAULT_ICE_WAIT; zinit $_ZLM "jreese/zsh-titles"
# note: if these fail to clone, try running the ice and load manually
# Only load these if the relevent program is installed
## adds clipboard helper functions to pipe into/out of clipboard
_ZINIT_DEFAULT_ICE_WAIT if"(( $+commands[xclip] ))"; zinit $_ZLM "zpm-zsh/clipboard"
## docker autocmplete
_ZINIT_DEFAULT_ICE_WAIT if"(( $+commands[docker] ))" pick"contrib/completion/zsh/_docker"
zinit $_ZLM "docker/cli"
## git
_ZINIT_SNIPPET_DEFAULT_ICE if"(( $+commands[git] ))"
if [[ -v _ZINIT_USE_SVN ]]; then
	zinit snippet OMZ::"plugins/git"
else
	zinit snippet OMZ::"plugins/git/git.plugin.zsh"
fi
## git flow
_ZINIT_DEFAULT_ICE_WAIT if"git flow version &>/dev/null"
zinit $_ZLM "petervanderdoes/git-flow-completion"
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
zinit ice lucid wait"$_ZINIT_WAIT" from"gh-r" as"program" bpick"*$_FZF_MACHINE*$_FZF_ARCH*" if"! (( $+commands[fzf] ))"
zinit $_ZLM junegunn/fzf-bin
### zsh support
_ZINIT_DEFAULT_ICE_WAIT pick"shell/*.zsh"
zinit $_ZLM "junegunn/fzf"
### set up FZF
#export FZF_COMPLETION_TRIGGER="tt"
## python virtual environment
_ZINIT_DEFAULT_ICE_WAIT if"(( $+commands[python3] ))"
zinit $_ZLM "MichaelAquilina/zsh-autoswitch-virtualenv"
### setup venv
export AUTOSWITCH_DEFAULT_PYTHON="/usr/bin/python3"

autoload -Uz compinit
compinit
