# add local-user executable folders to PATH
PATH="$HOME/bin:$HOME/usr/bin:$HOME/bin:$HOME/.local/bin:$PATH"

# add rust-lang's cargo executables to PATh
PATH="$HOME/.cargo/bin:$PATH"

# export PATH
export PATH

# add local stuff to library path
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/usr/lib:$HOME/lib:$HOME/.local/lib"
