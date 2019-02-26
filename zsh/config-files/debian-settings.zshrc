# settings for debian and derivates (ubuntu)

# if apt is installed prefer apt as it has colors and stuff
if type apt &>/dev/null ; then
	alias apt="apt"
# fall back to apt-get
else
	alias apt="apt-get"
fi

# aptupg
function aptupg()
{
	for arg in update upgrade autoremove autoclean; do
		sudo apt $arg
	done
}

function aptfullupg()
{
	for arg in update upgrade dist-upgrade autoremove autoclean; do
		sudo apt $arg
	done
}
