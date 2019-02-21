# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

# don't nice background processes on windows subsystem for linux, as it doesn't work
if [ "$(uname -r | sed 's/^.*-//')" = "Microsoft" ]; then
	unsetopt BG_NICE
fi

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
() {
	setopt local_options no_notify no_monitor

	_zplug_update & disown
}

# then load
zplug load

# zplug logs if $ZPLUG_LOADFILE isn't present, which it isn't for my use case of zplug
# this causes zplug's logging subsystem to take up a good chunk of startup time, so create that file if it doesn't exit
# this won't help the current shell, but it will fix it for the future
[[ ! -f "$ZPLUG_LOADFILE" ]] && touch $ZPLUG_LOADFILE

# set autosuggestions color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"

# Highlights the suggestions created by tab, eg; from `ls`
zstyle ':completion:*' menu select

# Highlight the substring in the suggestion list from `ls`
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# _ approximate (fuzzy) completion tries to complete things that are typed incorrectly.
# _expand expands variables.
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# Expand *all* variables
zstyle ':completion:*:expand:*' tag-order all-expansions

# Helpful completion feedback
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# some stuff from oh-my-zsh/lib/completion.zsh
## be hyphen-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

## use colors, based on oh-my-zsh and https://stackoverflow.com/a/23568183/943580
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:parameters'  list-colors '=*=32'
zstyle ':completion:*:commands' list-colors '=*=1;31'
zstyle ':completion:*:builtins' list-colors '=*=1;38;5;142'
zstyle ':completion:*:aliases' list-colors '=*=2;38;5;128'
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=33'
zstyle ':completion:*:options' list-colors '=^(-- *)=34'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

## add ps completion
if [[ "$OSTYPE" = solaris* ]]; then
	zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm"
else
	zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
fi

## disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-director

## Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR

## Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
	adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
	clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
	gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
	ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
	named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
	operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
	rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
	usbmux uucp vcsa wwwrun xfs '_*'

## ... unless we really want to.
zstyle '*' single-ignored show

## have waiting dots for completion
expand-or-complete-with-dots() {
	# toggle line-wrapping off and back on again
	[[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
	print -Pn "%{%F{red}......%f%}"
	[[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

	zle expand-or-complete
	zle redisplay
}

zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

# opts
setopt auto_cd # Just type the name of a cd'able location and press return to get there
setopt BANG_HIST # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS # Do not display a line previously found.
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY # Don't execute immediately upon history expansion.
setopt HIST_BEEP # Beep when accessing nonexistent history.
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol

# set up keyboard layout, dynamically with zkbd
autoload zkbd
ZKBD_FILE="${ZDOTDIR:-$HOME}/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}"
[[ ! -f "$ZKBD_FILE" ]] && zkbd
source "$ZKBD_FILE"
unset ZKBD_FILE

# bindkey, partially from tombh, and partially from several different posts in https://bbs.archlinux.org/viewtopic.php?id=26110
## Set home/end to go through history
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-history
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-history
## CTRL+ARROW to move by words, not handled by zkbd
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
## CTRL+BACKSPACE deletes whole word, not handled by zkbd
bindkey "^H" backward-delete-word
## Bind UP/DOWN to search through history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
## Page UP/DOWN to go through line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" beginning-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" end-of-line

# rest of the keys
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
