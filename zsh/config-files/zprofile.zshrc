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

# export PATH
export PATH

# add local stuff to library path
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/usr/lib:$HOME/lib:$HOME/.local/lib"
