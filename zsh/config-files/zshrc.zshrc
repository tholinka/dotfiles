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

# zinit setup
source "$ZSH_CONFIG/zinit.zshrc"

# machine specific settings, only source if its present
[[ -r $HOME/.zsh-local.zshrc ]] && source "$HOME/.zsh-local.zshrc"

# negs
source "$ZSH_CONFIG/ack.zshrc"
