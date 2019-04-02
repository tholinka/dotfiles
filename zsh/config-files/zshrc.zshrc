# make sure zprofile gets sourced, as for some reason it doesn't sometimes
# but only do it once so that if ```source ~/.zshrc``` is called we don't add paths again
[[ -v ZPROFILE_SOURCED ]] || source "$HOME/.zprofile" && export ZPROFILE_SOURCED=true

# Path to config folder if not already set
[[ -v ZSH_CONFIG ]] || export ZSH_CONFIG="$HOME/.zsh-config"

source $ZSH_CONFIG/zsh.zshrc
source $ZSH_CONFIG/zplugin.zshrc
source "$ZSH_CONFIG/functions.zshrc"
source "$ZSH_CONFIG/aliases.zshrc"
source "$ZSH_CONFIG/zsh.zshrc"
(( $+commands[pacman] )) && source "$ZSH_CONFIG/arch.zshrc"
(( $+commands[apt-get] )) && source "$ZSH_CONFIG/debian.zshrc"
(( $+commands[wine] )) && source "$ZSH_CONFIG/wine.zshrc"
(( $+commands[youtube-dl] )) && source "$ZSH_CONFIG/youtube-dl.zshrc"
source "$ZSH_CONFIG/nvm.zshrc"
source "$ZSH_CONFIG/variables.zshrc"
source "$HOME/.zsh-local.zshrc"
