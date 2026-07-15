# need compdef, but we use the zinit version, and the we run all our config before zinit finishes loading and triggers the real compinit
zicompinit

# load tmux first
source "$ZSH_CONFIG/plugins/tmux.plugin.zshrc"

# zsh settings
source "$ZSH_CONFIG/plugins/zsh.plugin.zshrc"

# general variables, used for instance in aliases
source "$ZSH_CONFIG/plugins/variables.plugin.zshrc"

# general functions, used for intsnace in aliases
source "$ZSH_CONFIG/plugins/functions.plugin.zshrc"

# general aliases
source "$ZSH_CONFIG/plugins/aliases.plugin.zshrc"

# command specific settings

(( $+commands[pacman] )) && source "$ZSH_CONFIG/plugins/arch.plugin.zshrc"
(( $+commands[apt-get] )) && source "$ZSH_CONFIG/plugins/debian.plugin.zshrc"
(( $+commands[wine] )) && source "$ZSH_CONFIG/plugins/wine.plugin.zshrc"
(( $+commands[youtube-dl] )) && source "$ZSH_CONFIG/plugins/youtube-dl.plugin.zshrc"
(( $+commands[docker] )) && source "$ZSH_CONFIG/plugins/docker.plugin.zshrc"
(( $+commands[git] )) && source "$ZSH_CONFIG/plugins/git.plugin.zshrc"
(( $+commands[java] )) && source "$ZSH_CONFIG/plugins/java.plugin.zshrc"
(( $+commands[basenc] )) && source "$ZSH_CONFIG/plugins/base64.plugin.zshrc"
(( $+commands[kubectl] )) && source "$ZSH_CONFIG/plugins/k8s.plugin.zshrc"
(( $+commands[bws] )) && source "$ZSH_CONFIG/plugins/bws.plugin.zshrc"
(( $+commands[chezmoi] )) && source "$ZSH_CONFIG/plugins/chezmoi.plugin.zshrc"

# nvm settings, sets up nvm if not present
source "$ZSH_CONFIG/plugins/nvm.plugin.zshrc"
