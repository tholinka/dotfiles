if [[ ! -v ACK_NO_ATUIN ]]; then
	if [[ -f "$HOME/.local/share/atuin/last_sync_time" ]]; then
		if [[ $(date -d $(<"$HOME/.local/share/atuin/last_sync_time") +%s) -le $(date -d "7 days ago" +%s) ]]; then
			echo "atuin last synced over a week ago? Ensure it is working correctly"
		fi
	else
		echo "atuin not configured. Configure atuin by running: atuin login -u tyler, then enter password and key. set ACK_NO_ATUIN=y to .zsh-local.zshrc to disable this message"
	fi
fi
