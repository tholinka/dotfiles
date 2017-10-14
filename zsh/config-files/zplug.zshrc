# originally based off of https://github.com/tombh/dotfiles/blob/master/.zshrc

# init zplug
source $ZSH_CONFIG/zplug/init.zsh

# base
zplug "zplug/zplug"

# oh-my-zsh plugins
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh

## arch plugin if we're using arch
if type pacman &>/dev/null; then
  zplug "plugins/archlinux", from:oh-my-zsh
fi

# oh-my-zsh theme
zplug "themes/agnoster", from:oh-my-zsh

# other plugins
## git prompt info
#zplug "tombh/zsh-git-prompt", as:plugin, use:zshrc.sh # my theme handles this
## don't run anything pasted until I manually hit enter key
zplug "oz/safe-paste"
## automatically change terminal title based on location / task
zplug "jreese/zsh-titles"
## additional zsh completions
zplug "zsh-users/zsh-completions"
## substring history search (type partial history and arrow key up/down to search history)
zplug "zsh-users/zsh-history-substring-search"
## google search (kind of) command suggestions
zplug "zsh-users/zsh-autosuggestions"
## syntax highlighting, defer so it load's later
zplug "zdharma/fast-syntax-highlighting", defer:3

# install plugins if there are any to install
if ! zplug check --verbose; then
  zplug install
fi

# then load
zplug load

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

# bindkey
## Ensure Home/End do what their meant to
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
## CTRL+ARROW to move by words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
## CTRL+BACKSPACE deletes whole word
bindkey "^H" backward-delete-word
## Bind UP/DOWN to search through history
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down