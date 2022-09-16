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
_ZLOAD_NON_DEBUG="silent light-mode lucid "
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

zinit ice blockf $_ZLOAD_NON_DEBUG wait"0d" if"(( $+commands[java] && ${+_MAC} ))"
zinit snippet "$ZSH_CONFIG/plugins/java.plugin.zsh"

# we use these annex's to load others
_zload for \
zdharma-continuum/zinit-annex-patch-dl \
zdharma-continuum/zinit-annex-bin-gem-node

### Theme note: if there is a "wait" present, it will fail to load on first prompt
### and will instead load after a command is entered
## Get theme from my fork
#_zload for "tholinka/agnoster-zsh-theme"
## Powerlevel10k
_zload for romkatv/powerlevel10k

# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#_zload wait"0a" for"tombh/zsh-git-prompt" # my theme handles this
## don't run anything pasted until I manually hit enter key
_zload wait"0a" for "oz/safe-paste"
## additional syntax highlighting, zsh completions, command suggestion
_zload wait"0zzz" for \
atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" zdharma-continuum/fast-syntax-highlighting \
zsh-users/zsh-completions \
atload"!_zsh_autosuggest_start" zsh-users/zsh-autosuggestions
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
_zload wait"0d" if"(( $+commands[python] )) || (( $+commands[python3] ))" for "MichaelAquilina/zsh-autoswitch-virtualenv"

# zinit packages
zinit blockf wait"0e" pack for dircolors-material

# FZF, hotkeys: ctrl-t file/dir search. ctrl-r history search, alt-c dir search + cd
zinit blockf wait"0z" pack"bgn-binary+keys" for fzf
