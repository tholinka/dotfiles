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

alias kgsecd="kubectl get secret -o go-template='"'{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'"'"
