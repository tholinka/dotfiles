# if running bash (from ubuntu's .profile)
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# add global executable folders to PATH
PATH="/bin:/usr/bin:/sbin:/usr/sbin:$PATH"

# add local-user executable folders to PATH
PATH="$HOME/bin:$HOME/usr/bin:$HOME/bin:$HOME/.local/bin:$PATH"

# add rust-lang's cargo executables to PATH
PATH="$HOME/.cargo/bin:$PATH"

# add Golang
export GOPATH="$HOME/.go"
export GOBIN="$HOME/.go/bin"
PATH="$GOBIN:$PATH"

# add rbenv
PATH="$HOME/.rbenv/bin:$PATH"

# add colorgcc
PATH="/usr/lib/colorgcc/bin:$PATH"

# mac?
if [[ $(uname -s) == Darwin* ]]; then
	# include coreutils
	PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi
export PATH

# add local stuff to library path, might already be added
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH${LD_LIBRARY_PATH+:}$HOME/usr/lib:$HOME/lib:$HOME/.local/lib"

# add ccache
export CCACHE_PATH="/usr/bin"
