if [[ ! -v ACK_NO_ATUIN ]]; then
	if (( $+commands[atuin] )); then
			_atuin_last_arr=($(atuin status | grep --color=never 'Last sync'))
			_atuin_last=${_atuin_last_arr[3]}T${_atuin_last_arr[4]}

	# this file no longer seems to be updated in newer versions of atuin
	# if [[ -f "$HOME/.local/share/atuin/last_sync_time" ]]; then
		# _atuin_last=$(<"$HOME/.local/share/atuin/last_sync_time")
		if [[ $(date -d "$_atuin_last" +%s) -le $(date -d "7 days ago" +%s) ]]; then
			echo "atuin last synced over a week ago? Ensure it is working correctly"
		fi
	else
		echo "atuin not configured. Configure atuin by running: atuin login -u tyler, then enter password and key. set ACK_NO_ATUIN=y to .zsh-local.zshrc to disable this message"
	fi
fi
