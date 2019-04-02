# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

LOCAL_PLUGINS="$ZSH_CONFIG/local-plugins"

# init zplugin
# this is compied directly from install.sh for zplugin
source "$ZSH_CONFIG/zplugin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
#end install.sh section from zplugin

_ZPLUGIN_WAIT=""
#_ZLM, to allow global switch between load and light
#_ZLM=load
_ZLM=light
alias _ZPLUGIN_DEFAULT_ICE="zplugin ice lucid wait\"\$_ZPLUGIN_WAIT\" depth\"1\" from\"github\""
# only use svn if its present
(( $+commands[svn] )) && _ZPLUGIN_snippet_svn="svn"
alias _ZPLUGIN_snippet_DEFAULT_ICE="zplugin ice lucid $_ZPLUGIN_snippet_svn wait\"\$_ZPLUGIN_WAIT\""
# oh-my-zsh plugins
_ZPLUGIN_snippet_DEFAULT_ICE; zplugin snippet OMZ::"plugins/colorize"
## oh-my-zsh theme
#_ZPLUGIN_snippet_DEFAULT_ICE pick"agnoster.zsh-theme"; zplugin snippet OMZ::"themes"
## Get theme from official repository instead
#_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "agnoster/agnoster-zsh-theme"
## Get theme from my fork
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "tholinka/agnoster-zsh-theme"

_ZPLUGIN_WAIT="0"
# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#_ZPLUGIN_DEFAULT_ICE
#zplugin $_ZLM "tombh/zsh-git-prompt" # my theme handles this
## don't run anything pasted until I manually hit enter key
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "oz/safe-paste"
## automatically change terminal title based on location / task
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "jreese/zsh-titles"
## additional zsh completions
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "zsh-users/zsh-completions"
## substring history search (type partial history and arrow key up/down to search history)
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "zsh-users/zsh-history-substring-search"
## command suggestions
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "zsh-users/zsh-autosuggestions"
## syntax highlighting
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "zdharma/fast-syntax-highlighting"
## 256color
#ZSH_256COLOR_DEBUG=true
_ZPLUGIN_DEFAULT_ICE; zplugin $_ZLM "chrissicool/zsh-256color"

_ZPLUGIN_WAIT="0"
# note: if these fail to clone, try running the ice and load manually
# Only load these if the relevent program is installed
## adds clipboard helper functions to pipe into/out of clipboard
_ZPLUGIN_DEFAULT_ICE if"(( $+commands[xclip] ))"; zplugin $_ZLM "zpm-zsh/clipboard"
## docker autocmplete
_ZPLUGIN_DEFAULT_ICE if"(( $+commands[docker] ))" pick"contrib/completion/zsh/_docker"
zplugin $_ZLM "docker/cli"
## git
_ZPLUGIN_snippet_DEFAULT_ICE if"(( $+commands[git] ))"
zplugin snippet OMZ::"plugins/git"
## git flow
_ZPLUGIN_DEFAULT_ICE if"git flow version &>/dev/null"
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
_FZF_MACHINE=${_FZF_MACHINE:=linux}
# to lower case
_FZF_MACHINE=$_FZF_MACHINE:l

#echo "Using arch: $_FZF_ARCH and machine $_FZF_MACHINE"
### actually try install
zplugin ice lucid wait"$_ZPLUGIN_WAIT" from"gh-r" as"program" bpick"*$_FZF_MACHINE*$_FZF_ARCH*" if"! (( $+commands[fzf] ))"
zplugin $_ZLM junegunn/fzf-bin
### zsh support
_ZPLUGIN_DEFAULT_ICE pick"shell/*.zsh"
zplugin $_ZLM "junegunn/fzf"

# set up FZF
#export FZF_COMPLETION_TRIGGER="tt"

autoload -Uz compinit
compinit
