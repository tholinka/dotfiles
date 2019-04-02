# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

LOCAL_PLUGINS="$ZSH_CONFIG/local-plugins"

# init zplugin
# this is compied directly from install.sh for zplugin
source "$ZSH_CONFIG/zplugin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
#end install.sh section from zplugin

ZPLUGIN_WAIT=""
#_ZLM, to allow global switch between load and light
#_ZLM=load
_ZLM=light
alias zplugin_default_ice="zplugin ice wait\"$ZPLUGIN_WAIT\" depth\"1\" from\"github\""

# oh-my-zsh plugins
zplugin ice svn wait"$ZPLUGIN_WAIT"; zplugin snippet OMZ::"plugins/colorize"
## oh-my-zsh theme
#zplugin ice svn wait"$ZLUGIN_WAIT" pick"agnoster.zsh-theme"; zplugin snippet OMZ::"themes"
## Get theme from official repository instead
#zplugin_default_ice; zplugin $_ZLM "agnoster/agnoster-zsh-theme"
## Get theme from my fork
zplugin_default_ice; zplugin $_ZLM "tholinka/agnoster-zsh-theme"

ZPLUGIN_WAIT="0"
# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#zplugin_default_ice
#zplugin $_ZLM "tombh/zsh-git-prompt" # my theme handles this
## don't run anything pasted until I manually hit enter key
zplugin_default_ice; zplugin $_ZLM "oz/safe-paste"
## automatically change terminal title based on location / task
zplugin_default_ice; zplugin $_ZLM "jreese/zsh-titles"
## additional zsh completions
zplugin_default_ice; zplugin $_ZLM "zsh-users/zsh-completions"
## substring history search (type partial history and arrow key up/down to search history)
zplugin_default_ice; zplugin $_ZLM "zsh-users/zsh-history-substring-search"
## command suggestions
zplugin_default_ice; zplugin $_ZLM "zsh-users/zsh-autosuggestions"
## syntax highlighting
zplugin_default_ice; zplugin $_ZLM "zdharma/fast-syntax-highlighting"
## 256color
#ZSH_256COLOR_DEBUG=true
zplugin_default_ice; zplugin $_ZLM "chrissicool/zsh-256color"

ZPLUGIN_WAIT="0"
# note: if these fail to clone, try running the ice and load manually
# Only load these if the relevent program is installed
## adds clipboard helper functions to pipe into/out of clipboard
zplugin_default_ice if"(( $+commands[xclip] ))"; zplugin $_ZLM "zpm-zsh/clipboard"
## docker autocmplete
zplugin_default_ice if"(( $+commands[docker] ))" pick"contrib/completion/zsh/_docker"
zplugin $_ZLM "docker/cli"
## git
zplugin ice svn wait"$ZPLUGIN_WAIT" if"(( $+commands[git] ))"
zplugin snippet OMZ::"plugins/git"
## git flow
zplugin_default_ice if"git flow version &>/dev/null"
zplugin $_ZLM "petervanderdoes/git-flow-completion"
## fuzzy search
### executable
#### try to decode which version to get
_FZF_ARCH="$(uname -m)"
if [[ $_FZF_ARCH == "x86_64" ]]; then
	_FZF_ARCH="amd64"
fi
_FZF_MACHINE="$(uname)"
# set default to linux
_FZF_MACHINE=${_FZF_MACHINE:=linux}
# to lower case
_FZF_MACHINE=$_FZF_MACHINE:l

zplugin ice wait"$ZPLUGIN_WAIT" from"gh-r" as"program" bpick"*$_FZF_MACHINE*$_FZF_ARCH*" if"! (( $+commands[fzf] ))"
zplugin $_ZLM junegunn/fzf-bin
### zsh support
zplugin_default_ice pick"shell/*.zsh"
zplugin $_ZLM "junegunn/fzf"

# set up FZF
#export FZF_COMPLETION_TRIGGER="tt"

autoload -Uz compinit
compinit