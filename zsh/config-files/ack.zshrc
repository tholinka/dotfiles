if [[ ! -v _ZINIT_USING_MODULE ]] && [[ ! -v ACK_NO_ZINIT_MODULE ]]; then
	function zinit-module-build() (
		set -e
		cd ~/.local/share/zinit
		if [[ ! -d module ]]; then
			git clone https://github.com/zdharma-continuum/zinit-module.git module
		fi

		cd module
		git remote -v | grep -w aloxaf 1>/dev/null || git remote add aloxaf https://github.com/Aloxaf/zinit-module.git
		git fetch aloxaf
		# sadly zinit module build doesn't work for aarch64
		git checkout -B fix_zsh_5.8.1 -t aloxaf/fix_zsh_5.8.1
		./configure --build $(uname -m)-unknown-linux-gnu -q --disable-gdbm
		make -s
	)
	echo "zinit module not built. Build with \"zinit-module-build\". To ignore this message, and not display it in the future, run the build command, or add ACK_NO_ZINIT_MODULE=y to your .zsh-local.zshrc"
fi

if [[ ! -v ACK_NO_ATUIN ]]; then
	if [[ -f "$HOME/.local/share/atuin/last_sync_time" ]]; then
		if [[ $(date -d $(<"$HOME/.local/share/atuin/last_sync_time") +%s) -le $(date -d "7 days ago" +%s) ]]; then
			echo "atuin last synced over a week ago? Ensure it is working correctly"
		fi
	else
		echo "atuin not configured. Configure atuin by running: atuin login -u tyler, then enter password and key. set ACK_NO_ATUIN=y to .zsh-local.zshrc to disable this message"
	fi
fi
