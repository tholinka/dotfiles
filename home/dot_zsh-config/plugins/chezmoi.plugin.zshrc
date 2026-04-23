alias cz="chezmoi"
alias czcd="cd $(chezmoi source-path)"
alias czd="chezmoi diff"
alias czs="chezmoi status"
alias czap="chezmoi apply"
alias czad="chezmoi add"
alias cze="chezmoi edit"
alias czec="chezmoi edit-config"
alias czu="chezmoi update"
alias czup="chezmoi update --apply"

### originally from oh-my-zsh at https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/chezmoi/chezmoi.plugin.zsh
# COMPLETION FUNCTION
# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `chezmoi`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_chezmoi" ]]; then
  typeset -g -A _comps
  autoload -Uz _chezmoi
  _comps[chezmoi]=_chezmoi
fi

chezmoi completion zsh >| "$ZSH_CACHE_DIR/completions/_chezmoi" &|
