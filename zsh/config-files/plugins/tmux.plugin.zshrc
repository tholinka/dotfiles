if ! (( $+commands[tmux] )); then
  print "zsh tmux plugin: tmux not found. Please install tmux before using this plugin." >&2
  return 1
fi

# CONFIGURATION VARIABLES
# Automatically start tmux
: ${ZSH_TMUX_AUTOSTART:=false}
# Automatically close the terminal when tmux exits
: ${ZSH_TMUX_AUTOQUIT:=$ZSH_TMUX_AUTOSTART}
# Set term to screen or screen-256color based on current terminal support
: ${ZSH_TMUX_FIXTERM:=true}
# Set '-CC' option for iTerm2 tmux integration
has_iterm="$((( $+ITERM_SESSION_ID )) && echo true || echo false)"
: ${ZSH_TMUX_ITERM2:=$has_iterm}
# The TERM to use for non-256 color terminals.
# Tmux states this should be screen, but you may need to change it on
# systems without the proper terminfo
: ${ZSH_TMUX_FIXTERM_WITHOUT_256COLOR:=screen}
# The TERM to use for 256 color terminals.
# Tmux states this should be screen-256color, but you may need to change it on
# systems without the proper terminfo
: ${ZSH_TMUX_FIXTERM_WITH_256COLOR:=screen-256color}
# Set the configuration path
: ${ZSH_TMUX_CONFIG:=$HOME/.tmux.conf}
# Set -u option to support unicode
: ${ZSH_TMUX_UNICODE:=true}

# ALIASES
alias tma='tmux attach -t'
alias tmad='tmux attach -d -t'
alias tms='tmux new-session -s'
alias tmls='tmux list-sessions'
alias tmks='tmux kill-server'
alias tmkss='tmux kill-session -t'
alias tmuxconf='$EDITOR $ZSH_TMUX_CONFIG'

# Determine if the terminal supports 256 colors
if [[ $terminfo[colors] == 256 ]]; then
	export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITH_256COLOR
else
	export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR
fi

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

export _IS_WSL=$(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip')

# Set the correct local config file to use.
export _ZSH_TMUX_FIXED_CONFIG="$ZSH_CONFIG/tmux/tmux.conf"
export _ZSH_TMUX_FIXED_CONFIG_ITERM2="$ZSH_CONFIG/tmux/iterm2.conf"
export _ZSH_TMUX_FIXED_CONFIG_WSL="$ZSH_CONFIG/tmux/wsl.conf"
# Wrapper function for tmux.
function _zsh_tmux_plugin_run() {
	if [[ -n "$@" ]]; then
		command tmux "$@"
		return $?
	fi

	local -a tmux_cmd
	tmux_cmd=(command tmux)
	[[ "$ZSH_TMUX_ITERM2" == "true" ]] && tmux_cmd+=(-CC)
	[[ "$ZSH_TMUX_UNICODE" == "true" ]] && tmux_cmd+=(-u)

	if [[ "$ZSH_TMUX_FIXTERM" == "true" ]]; then
		if [[ "$_IS_WSL" == "microsoft" ]]; then
			tmud_cmd+=(-f "$_ZSH_TMUX_FIXED_CONFIG_WSL")
		elif [[ "$ZSH_TMUX_ITERM2" == "true" ]]; then
			tmux_cmd+=(-f "$_ZSH_TMUX_FIXED_CONFIG_ITERM2")
		else
			tmux_cmd+=(-f "$_ZSH_TMUX_FIXED_CONFIG")
		fi
	elif [[ -e "$ZSH_TMUX_CONFIG" ]]; then
		tmux_cmd+=(-f "$ZSH_TMUX_CONFIG")
	fi

	local -a existing
	existing="$(command tmux ls | grep -v attached | awk -F ':' '{print $1}' | head -n 1)"
	if [[ -n $existing ]]; then
		$tmux_cmd attach -t $existing
	elif [[ -n "$ZSH_TMUX_DEFAULT_SESSION_NAME" ]]; then
		$tmux_cmd new-session -s $ZSH_TMUX_DEFAULT_SESSION_NAME
	else
		$tmux_cmd new-session
	fi

	if [[ "$ZSH_TMUX_AUTOQUIT" == "true" ]]; then
		exit
	fi
}

# Use the completions for tmux for our function
compdef _tmux _zsh_tmux_plugin_run
# Alias tmux to our wrapper function.
alias tmux=_zsh_tmux_plugin_run

# Autostart if not already in tmux and enabled.
if [[ -z "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" ]]; then
  # Actually don't autostart if we already did and multiple autostarts are disabled.
  if [[ "$ZSH_TMUX_AUTOSTART_ONCE" == "false" || "$ZSH_TMUX_AUTOSTARTED" != "true" ]]; then
	export ZSH_TMUX_AUTOSTARTED=true
	_zsh_tmux_plugin_run
  fi
fi
