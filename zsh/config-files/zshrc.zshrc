# make sure zprofile gets sourced, as for some reason it doesn't sometimes
# but only do it once so that if ```source ~/.zshrc``` is called we don't add paths again
[[ -v ZPROFILE_SOURCED ]] || source "$HOME/.zprofile"

# Path to config folder if not already set
[[ -v ZSH_CONFIG ]] || export ZSH_CONFIG="$HOME/.zsh-config"

# Path to zplugin folder, if not already set
[[ -v ZPLG_HOME ]] || export ZPLG_HOME="$HOME/.zplugin"

# zplugin setup
source "$ZSH_CONFIG/zplugin.zshrc"
# zsh settings
source "$ZSH_CONFIG/zsh.zshrc"
# general variables, used for instance in aliases
source "$ZSH_CONFIG/variables.zshrc"
# general functions, used for intsnace in aliases
source "$ZSH_CONFIG/functions.zshrc"
# general aliases
source "$ZSH_CONFIG/aliases.zshrc"
# command specific settings
(( $+commands[pacman] )) && source "$ZSH_CONFIG/arch.zshrc"
(( $+commands[apt-get] )) && source "$ZSH_CONFIG/debian.zshrc"
(( $+commands[wine] )) && source "$ZSH_CONFIG/wine.zshrc"
(( $+commands[youtube-dl] )) && source "$ZSH_CONFIG/youtube-dl.zshrc"
(( $+commands[docker] )) && source "$ZSH_CONFIG/docker.zshrc"
(( $+commands[git] )) && source "$ZSH_CONFIG/git.zshrc"
# nvm settings, sets up nvm if not present
source "$ZSH_CONFIG/nvm.zshrc"
# machine specific settings, only source if its present
[[ -r $HOME/.zsh-local.zshrc ]] && source "$HOME/.zsh-local.zshrc"

# negs
source "$ZSH_CONFIG/ack.zshrc"
