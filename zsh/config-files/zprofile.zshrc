# add global executable folders to PATH
PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# add local-user executable folders to PATH
PATH="$HOME/bin:$HOME/usr/bin:$HOME/bin:$HOME/.local/bin:$PATH"

# add rust-lang's cargo executables to PATH
PATH="$HOME/.cargo/bin:$PATH"

# add Golang
export GOPATH=~/.go
export GOBIN=~/.go/bin
PATH="$GOBIN:$PATH"

# add rbenv
PATH="$HOME/.rbenv/bin:$PATH"

# add snap
PATH="/snap/bin:$PATH"

# add colorgcc
PATH="/usr/lib/colorgcc/bin:$PATH"

export PATH

# add local stuff to library path, might already be added
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH${LD_LIBRARY_PATH+:}$HOME/usr/lib:$HOME/lib:$HOME/.local/lib"

# add ccache
export CCACHE_PATH="/usr/bin"

# notify that this file was ran
export ZPROFILE_SOURCED=true
