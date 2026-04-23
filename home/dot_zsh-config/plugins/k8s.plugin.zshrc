# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `kubectl`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_stern" ]]; then
	typeset -g -A _comps
	autoload -Uz _stern
	_comps[stern]=_stern
fi

if (( $+commands[stern] )); then
	stern --completion=zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_stern" &|
fi

if (( $+commands[kubecolor] )); then
	alias kubectl="kubecolor"
	compdef kubecolor=kubectl
fi

source "$ZSH_CONFIG/completions/_kubectl-decode"
typeset -g -A _comps
autoload -Uz _kubectl-decode
_comps[kubectl-decode]=_kubectl-decode

alias kgsecd="kubectl-decode"

if (( $+commands[kubectl-cnpg] )); then
	typeset -g -A _comps
	autoload -Uz _kubectl-cnpg
	_comps[kubectl-cnpg]=_kubectl-cnpg
	kubectl-cnpg completion zsh 2>/dev/null >| "$ZSH_CACHE_DIR/completions/_kubectl-cnpg" &|
fi
