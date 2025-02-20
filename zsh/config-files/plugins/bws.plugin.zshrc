# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `bws`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_bws" ]]; then
  typeset -g -A _comps
  autoload -Uz _bws
  _comps[bws]=_bws
fi

bws completions zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_bws" &|
