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
