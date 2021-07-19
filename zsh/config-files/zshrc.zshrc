# load instant minimal prompt
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# make sure zprofile gets sourced, as for some reason it doesn't sometimes
# but only do it once so that if ```source ~/.zshrc``` is called we don't add paths again
[[ -v ZPROFILE_SOURCED ]] || source "$HOME/.zprofile"

# Path to config folder if not already set
[[ -v ZSH_CONFIG ]] || export ZSH_CONFIG="$HOME/.zsh-config"

# Path to zinit folder, if not already set
[[ -v ZPLG_HOME ]] || export ZPLG_HOME="$HOME/.zinit"

# mac or linux?
if [[ $(uname -s) == Darwin* ]]; then
export _MAC=true
fi

# zinit setup
source "$ZSH_CONFIG/zinit.zshrc"
# zsh settings
source "$ZSH_CONFIG/zsh.zshrc"
# general variables, used for instance in aliases
source "$ZSH_CONFIG/variables.zshrc"
# general functions, used for intsnace in aliases
source "$ZSH_CONFIG/functions.zshrc"
# general aliases
source "$ZSH_CONFIG/aliases.zshrc"

# load full prompt
source "$ZSH_CONFIG/powerlevel10k.zshrc"

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
