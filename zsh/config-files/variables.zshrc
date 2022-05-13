# Changes the command execution timestamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="yyyy-mm-dd"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export _PROCESSORS="$(nproc --all)"

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"
export USE_CCACHE=1
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
## roughly from arch's /etc/makepkg.conf, with a few changes
export CARCH="$(uname -m)"
### exported as _ so that they can be easily source (e.g. export CPPFLAGS="$_CPPFLAGS") without breaking builds
export _CPPFLAGS="-D_FORTIFY_SOURCE=2"
export _CFLAGS="-march=native -mtune=native -O2 -pipe -fno-plt"
export _CXXFLAGS="$_CFLAGS"
export _DFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
export _DEBUG_CFLAGS="-g -fvar-tracking-assignments"
export _DEBUG_CXXFLAGS="$_DEBUG_CFLAGS"
export _MAKEFLAGS="-j$_PROCESSORS"

# see if we're not suppose to define the default build variables
if ! [[ -v NO_BUILD_DEFINES ]]; then
	export CPPFLAGS="$_CPPFLAGS"
	export CFLAGS="$_CFLAGS"
	export CXXFLAGS="$_CXXFLAGS"
	export DFLAGS="$_DFLAGS"
	export DEBUG_CFLAGS="$_DEBUG_CFLAGS"
	export DEBUG_CXXFLAGS="$_DEBUG_CXXFLAGS"
fi
# always define MAKEFLAGS
export MAKEFLAGS="$_MAKEFLAGS"

# set up gpg
export GPG_TTY=$(tty)

# set up devkitpro location if not already set
if [ -z ${DEVKITPRO+x} ]; then
	export DEVKITPRO="/opt/devkitpro"
fi

# set up devkitARCH variables
export DEVKITARM="$DEVKITPRO/devkitARM"
export DEVKITPPC="$DEVKITPPC/devkitPPC"
export DEVKITA64="$DEVKITPRO/devkitA64"

# set up java home information
if [ -z ${_MAC+x} ]; then
	JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
else
	JAVA_HOME=$(/usr/libexec/java_home)
fi

[[ -d $JAVA_HOME ]] && export JAVA_HOME

# set up stuff for react-native / android builds
## prioritise local installs
if [[ -d $HOME/Android/Sdk ]]; then
	export ANDROID_HOME="$HOME/Android/Sdk"
	export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
# see system level installs
elif [[ -d /opt/android-sdk/ ]]; then
	export ANDROID_HOME="/opt/android-sdk"
	export ANDROID_SDK_ROOT="/opt/android-sdk"
fi
# add to path
if ! [[ -v $ANDOID_HOME ]]; then
	export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi
# we use this to build react-native's api in docker-compose
# this will contain "your" ip (e.g. the first hop ip, aka according to your gateway)
# this obviously isn't completely optimal, but it works well enough for desktops or often opened/closed ssh sessions
export IP=$(ip -4 route get 1.1.1.1 2>/dev/null | awk {'print $7'} | tr -d '[:space:]')

# set up default user for theme
[[ -v DEFAULT_USER_SETUP ]] || export DEFAULT_USER="$(whoami)" && DEFAULT_USER_SETUP=yes

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
	export _WAYLAND=true
fi

# FZF
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
# zsh-autoswitch-virtualenv plugin
export AUTOSWITCH_DEFAULT_PYTHON="/usr/bin/python3"
