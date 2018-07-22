# settings for debian and derivates (ubuntu)

# if apt is installed prefer apt as it has colors and stuff
if type apt &>/dev/null ; then
    alias apt="apt"
# fall back to apt-get
elif type apt-get &>/dev/null ; then
    alias apt="apt-get"
fi

# did we actually alias apt?
if type apt &>/dev/null ; then

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

    # alias to pacman commands for ultimate laziness
    alias pacup="aptupg"
    alias pacupg="aptfullupg"
    alias pacin="sudo apt install"
    alias pacrem="sudo apt purge"
    alias pacrmorphans="sudo apt autoremove"
fi