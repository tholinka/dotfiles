# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

# set up some zplug environmental variables
ZPLUG_THREADS="$(nproc --all 2>/dev/null || echo 8)"
ZPLUG_PROTOCOL="HTTPS"
ZPLUG_LOG_LOAD_SUCCESS="false"
ZPLUG_LOG_LOAD_FAILURE="true"

# init zplug
source "$ZSH_CONFIG/zplug/init.zsh"

# base
zplug "zplug/zplug"

# oh-my-zsh plugins
zplug "plugins/colorize", from:oh-my-zsh
## oh-my-zsh theme
#zplug "themes/agnoster", from:oh-my-zsh
## Get theme from official repository instead
#zplug "agnoster/agnoster-zsh-theme", as:theme
## Get theme from my fork
zplug "tholinka/agnoster-zsh-theme", as:theme

# other plugins (defer as much as possible to hopefully improve load times)
## git prompt info
#zplug "tombh/zsh-git-prompt", as:plugin, use:zshrc.sh # my theme handles this
## don't run anything pasted until I manually hit enter key
zplug "oz/safe-paste"
## automatically change terminal title based on location / task
zplug "jreese/zsh-titles", defer:3
## additional zsh completions
zplug "zsh-users/zsh-completions", defer:2
## substring history search (type partial history and arrow key up/down to search history)
zplug "zsh-users/zsh-history-substring-search", defer:2
## command suggestions
zplug "zsh-users/zsh-autosuggestions", defer:2
## syntax highlighting
zplug "zdharma/fast-syntax-highlighting", defer:2
## 256color
#ZSH_256COLOR_DEBUG=true
zplug "chrissicool/zsh-256color", defer:3

# Only load these if the relevent program is installed
## adds clipboard helper functions to pipe into/out of clipboard
zplug "zpm-zsh/clipboard", if:"(( $+commands[xclip] ))", defer:3
## docker autocmplete
zplug "plugins/docker", from:oh-my-zsh, if:"(( $+commands[docker] ))", defer:3
## git
zplug "plugins/git", from:oh-my-zsh, if:"(( $+commands[git] ))", defer:3
## git flow
zplug "petervanderdoes/git-flow-completion", if:"git flow version &>/dev/null", defer:3
## fuzzy search
### executable
#zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"fzf*linux_amd64*"
### zsh support
#zplug "junegunn/fzf", use:"shell/*.zsh", defer:2 #, if:"(( $+commands[fzf] ))", defer:3

# install plugins if there are any to install
if ! zplug check; then
	zplug install
fi

# do this in a function, as zplug status takes a while (~a few seconds at least)
function _zplug_update() {
	# check if there are any plugins to update
	if zplug status | grep "Run 'zplug update'." >/dev/null; then
		zplug update

		# only running clean on update, just so we don't clean every load
		zplug clean
	fi
}

# run the above update in the background
# do this in an anonomous function so it doesn't notify that we're running in the background
# disabled as it sometimes never exits.  and sometimes causes zsh to never finish loading its config
#() {
#	setopt local_options no_notify no_monitor

	# DON'T DISOWN, it causes the zsh process to occasionally never exit; sadly this means we will be notified on exit, and the background process will show up in the prompt
#	_zplug_update & #disown
#}

# then load
zplug load

# zplug logs if $ZPLUG_LOADFILE isn't present, which it isn't for my use case of zplug
# this causes zplug's logging subsystem to take up a good chunk of startup time, so create that file if it doesn't exit
# this won't help the current shell, but it will fix it for the future
[[ ! -f "$ZPLUG_LOADFILE" ]] && touch $ZPLUG_LOADFILE
