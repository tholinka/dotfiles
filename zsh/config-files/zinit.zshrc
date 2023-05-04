# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

# zinit, when using the module, can cause issues if sourced twice, so don't allow that
# also, if there ARE issues, delete the *.zwc files in ~/.zsh-config
if (( $+_ZINIT_USING_MODULE )); then
	return;
fi

# this is copied directly from install.sh for zinit
source "$ZSH_CONFIG/zinit/zinit.zsh"
autoload -Uz _zinit

# start zinit
# use module if avilable
_ZINIT_MODULE_PATH="${ZINIT[MODULE_DIR]}/Src"
if [[ -r "$_ZINIT_MODULE_PATH/zdharma_continuum/zinit.so" ]]; then
	module_path+=( "$_ZINIT_MODULE_PATH" )
	zmodload zdharma_continuum/zinit
	_ZINIT_USING_MODULE=yes
fi

(( ${+_comps} )) && _comps[zinit]=_zinit
#end install.sh section from zinit

# we want light and lucid added if not debugging
_ZLOAD_NON_DEBUG="lucid light-mode "
# Load these things immediatly
# we construct this in a way that the values of the variables are ran at run time, so we can change the "wait" on the fly
alias _zload="zinit blockf $_ZLOAD_NON_DEBUG"'depth"1" from"github"'
# only use svn if its present
(( $+commands[svn] )) && _ZINIT_USE_SVN="yes"

# oh-my-zsh plugins
_zload svn for \
wait"0d" OMZ::"plugins/command-not-found" \
wait"0d" if"(( $+commands[gradle] ))" OMZ::"plugins/gradle" \
wait"0b" if"(( $+_MAC ))" OMZ::"plugins/macos" \
wait"0b" if"(( $+commands[git] ))" OMZ::"plugins/git"


# mac or linux?
zinit ice $_ZLOAD_NON_DEBUG wait'0a' if"[[ $(uname -s) == Darwin* ]]"
zinit snippet "$ZSH_CONFIG/plugins/mac.plugin.zshrc"

# load tmux first
zinit ice $_ZLOAD_NON_DEBUG if"(( $+commands[tmux] ))" atinit"ZSH_TMUX_AUTOSTART=true"
zinit snippet "$ZSH_CONFIG/plugins/tmux.plugin.zshrc"

# zsh settings
zinit ice light-mode ludid wait"0a"
zinit snippet "$ZSH_CONFIG/plugins/zsh.plugin.zshrc"
# general variables, used for instance in aliases
zinit ice $_ZLOAD_NON_DEBUG wait"0b"
zinit snippet "$ZSH_CONFIG/plugins/variables.plugin.zsh"
# general functions, used for intsnace in aliases
zinit ice $_ZLOAD_NON_DEBUG wait"0b"
zinit snippet "$ZSH_CONFIG/plugins/functions.plugin.zshrc"
# general aliases
zinit ice $_ZLOAD_NON_DEBUG wait"0c"
zinit snippet "$ZSH_CONFIG/plugins/aliases.plugin.zshrc"

# command specific settings
zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[pacman] ))"
zinit snippet "$ZSH_CONFIG/plugins/arch.plugin.zshrc"
zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[apt-get] ))"
zinit snippet "$ZSH_CONFIG/plugins/debian.plugin.zshrc"
zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[wine] ))"
zinit snippet "$ZSH_CONFIG/plugins/wine.plugin.zshrc"
zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[youtube-dl] ))"
zinit snippet "$ZSH_CONFIG/plugins/youtube-dl.plugin.zshrc"
zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[docker] ))"
zinit snippet "$ZSH_CONFIG/plugins/docker.plugin.zshrc"
zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[git] ))"
zinit snippet "$ZSH_CONFIG/plugins/git.plugin.zshrc"

zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[java] ))"
zinit snippet "$ZSH_CONFIG/plugins/java.plugin.zsh"

zinit ice $_ZLOAD_NON_DEBUG wait"0z" if"(( $+commands[basenc] ))"
zinit snippet "$ZSH_CONFIG/plugins/base64.plugin.zsh"

# nvm settings, sets up nvm if not present
zinit ice $_ZLOAD_NON_DEBUG wait"0z"
zinit snippet "$ZSH_CONFIG/plugins/nvm.plugin.zshrc"

# we use these annex's to load others
_zload for \
wait'0a' zdharma-continuum/zinit-annex-patch-dl \
wait'0a' zdharma-continuum/zinit-annex-bin-gem-node

### Theme note: if there is a "wait" present, it will fail to load on first prompt
### and will instead load after a command is entered
## Get theme from my fork
#_zload for "tholinka/agnoster-zsh-theme"
## Powerlevel10k
_zload for romkatv/powerlevel10k
# load full prompt
zinit ice $_ZLOAD_NON_DEBUG
zinit snippet "$ZSH_CONFIG/plugins/powerlevel10k.plugin.zshrc"

# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#_zload wait"0a" for"tombh/zsh-git-prompt" # my theme handles this
## don't run anything pasted until I manually hit enter key
_zload wait"0a" for "oz/safe-paste"
## additional syntax highlighting, zsh completions, command suggestion
_zload wait"0zzz" for \
atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
zsh-users/zsh-completions \
atload"!_zsh_autosuggest_start; _zsh_autosuggest_bind_widgets" zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
## 256color
#ZSH_256COLOR_DEBUG=true
_zload wait"0a" for "chrissicool/zsh-256color"

## automatically change terminal title based on location / task
_zload wait"0e" for "jreese/zsh-titles"
# note: if these fail to clone, try running the ice and load manually
# Only load these if the relevent program is installed
## adds clipboard helper functions to pipe into/out of clipboard
_zload wait"0d" if"(( $+commands[xclip] ))" for "zpm-zsh/clipboard"
## docker autocmplete
_zload wait"0d" if"(( $+commands[docker] ))" pick"contrib/completion/zsh/_docker" for "docker/cli"
## git flow
_zload wait"0d" if"git flow version &>/dev/null" for "petervanderdoes/git-flow-completion"
## python virtual environment
_zload wait"0d" if"(( $+commands[python] ))" for "MichaelAquilina/zsh-autoswitch-virtualenv"

# zinit packages
zinit blockf $_ZLOAD_NON_DEBUG wait"0e" pack for dircolors-material

# FZF, hotkeys: ctrl-t file/dir search. ctrl-r history search, alt-c dir search + cd
zinit blockf $_ZLOAD_NON_DEBUG wait"1" pack"bgn-binary+keys" for fzf
