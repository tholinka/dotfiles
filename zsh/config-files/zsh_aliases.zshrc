ALIASES_FILE_LOC="${(%):-%N}" # hacky workaround to replace bash's export

# color stuff

COL_OPT="--color=always"

# switch ls to exa if it exists
ls="ls"
if type exa &> /dev/null ; then
    ls="exa"
fi

# ls options that are the same for ls and exa, set to always use color
alias ls="$ls $COL_OPT --group-directories-first"

# add color support to a bunch of commands
alias dir="dir $COL_OPT"
alias vdir="vdir $COL_OPT"

# there are to many different greps
alias bzgrep="bzgrep $COL_OPT"
alias egrep="egrep $COL_OPT"
alias fgrep="fgrep $COL_OPT"
alias grep="grep $COL_OPT"
alias pgrep="pgrep $COL_OPT"
alias xzgrep="xzgrep $COL_OPT"
alias zegrep="zegrep $COL_OPT"
alias zfgrep="zfgrep $COL_OPT"
alias zgrep="zgrep $COL_OPT"
alias zipgrep="zipgrep $COL_OPT"

alias dmesg="sudo dmesg $COL_OPT"

alias fdisk="sudo fdisk $COL_OPT"
alias fdiskl="fdisk -l"

alias diff="diff $COL_OPT"

# color less
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -a'
alias l='ls -F'

# have top use color (even if it's ugly af)
alias top="top -c"
# make iotop easier to use
alias iotop="sudo iotop -Pao"
# add default glances stuff
alias glances="glances -t 5"

# set resolution to 1080p, mostly useful in vms
alias fixres="xrandr --newmode \"1920x1080\"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync && xrandr --addmode Virtual1 1920x1080 && xrandr --output Virtual1 --mode 1920x1080"

alias c="clear"
alias get="git"
alias gitk="gitk &>/dev/null & "
alias gitgui="git gui &>/dev/null &"

# semi-useful upgrade function for debian based distros
if type "apt" &> /dev/null ; then
    alias aptupdateall="sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y"
fi

# following ~4 functions attempt to let you do a git command on multiple subdirs - easy enough, but then it also tries to color errors, which is a bit harder
function color_err()
{
    # Execute command
    "$@" 2> >(while read line; do echo -e "\e[01;31m$line\e[0m" | tee --append $TMP_ERRS; done)
    EXIT_CODE=$?

    # Finish
    return $EXIT_CODE
}

function git_step()
{
    # $1 is directory
    echoAble="$1: $(color_err git -C $1 ${@:2})"
    echo "$echoAble"

    return 0
}

function gitall()
{
    git_step . pull
    ls -R --directory --color=never */.git |
     sed 's/\/.git//' |
     xargs -P10 -I{} zsh -c ". $ALIASES_FILE_LOC ; git_step {} pull"; # hacky workaround to get around the fact that zsh doesn't have export -f
}

function gitcheckall()
{
    if [ -z "$1" ]; then
        branch="master"
    else
        branch="$1"
    fi

    git_step . checkout $branch
    ls -R --directory --color=never */.git |
     sed 's/\/.git//' |
     xargs -P10 -I{} zsh -c ". $ALIASES_FILE_LOC ; git_step {} checkout $branch"; # see gitall for hacky workaround reason
}

# grep wrapper (even though it's called findhere) that does grep --include "..." --exclude "..." -Rnwi . -e "[pattern]" in an easy function of findhere [pattern] [exclude] [include]
function findhere()
{
    # echo "findhere pattern exclude include e.g. findhere \"hello world\" \"*.o\" \"*.{c,h}\""
    if [ -z "$2" ]; then
        exclude=""
    else
        exclude="--exclude=$2 "
    fi

    if [ -z "$3" ]; then
        include=""
    else
        include="--include=$3 "
    fi

    echo "searching for \"$1\" with include of \"$2\" and exclude of \"$3\""

    grep "$include" "$exclude" -Rnwi . -e \""$1"\" || echo "nothing found"
}

# wrap a few youtube-dl commands, e.g. youtube-mp3 [video] and vimeo-password [video] [password]
YOUTUBE_DL_OUTPUT_FOLDER="$HOME/Downloads/youtube-dl"
YOUTUBE_DL_OUTPUT_FILE="%(title)s.%(ext)s"
YOUTUBE_DL_OUTPUT="-o$YOUTUBE_DL_OUTPUT_FILE"

function check-youtube-dl-loc()
{
    if [ ! -d "$YOUTUBE_DL_OUTPUT_FOLDER" ]; then
        mkdir "$YOUTUBE_DL_OUTPUT_FOLDER"
    fi
}

function youtube-mp3()
(
    check-youtube-dl-loc

    cd "$YOUTUBE_DL_OUTPUT_FOLDER"

    youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 "$YOUTUBE_DL_OUTPUT" "$@" || echo "Usage: youtube-mp3 VIDEO-URL"
)

function vimeo-password()
(
    check-youtube-dl-loc

    cd "$YOUTUBE_DL_OUTPUT_FOLDER"

    youtube-dl "$1" --video-password "$2" "$YOUTUBE_DL_OUTPUT" "${@:3}" || echo "Usage: vimeo-password VIDEO-URL PASSWORD"
)

if which wine &> /dev/null ; then
    # probably want to install some lib32 libs: lib32-cairo lib32-libcups lib32-gnutls lib32-gtk3 lib32-v4l-utils lib32-libva lib32-libxcomposite lib32-libxinerama lib32-libxslt lib32-libxml2 lib32-mpg123 lib32-lcms2 lib32-giflib lib32-libpng lib32-gnutls
    # and lib32-libva-vdpau-driver if on nvidia, lib32-libva-intel-driver if using intel graphics
    # also winecfg -> staging -> Enable CSMT, Enable VAAPI, Enable GTK3
    # set up some wine stuff
    export WINEDEBUG=-all

    # run this at some point, really don't need to be done on every shell tho
    # it sets up a paged pool size for wine, source games require it
    # wine reg add "HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Memory Management\\" /v PagedPoolSize /t REG_DWORD /d 402653184 /f
    # also link system fonts:  cd ${WINEPREFIX:-~/.wine}/drive_c/windows/Fonts && for i in /usr/share/fonts/**/*.{ttf,otf}; do ln -s "$i" ; done

    # see if steam is installed, assumes 64bit wine
    if [ -d ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam ]; then
        # run wine reg.exe ADD "HKEY_CURRENT_USER\Software\Wine\AppDefaults\Steam.exe" /v "Version" /t "REG_SZ" /d "winxp" /f to run steam under xp mode
        alias steam-wine="env WINEPREFIX=\"/home/tyler/.wine\" wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-cef-sandbox &>/dev/null & disown"

        # see if path of exile is installed
        if [ -d  ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/steamapps/common/Path\ of\ Exile ]; then
            # need some 32 bit libs:
            # lib32-libldap lib32-alsa-plugins lib32-libpulse lib32-openal
            # https://appdb.winehq.org/objectManager.php?sClass=version&iId=25078&iTestingId=95811
            # launch with garbage collector set to 100, will eventually run out of ram, but it reduces lag a ton
            # also, run winetricks glsl=disable ; winetricks vcrun2010 usp10
            # also set ~/Documents/My Games/Path of Exile/production_Config.ini to
            # [GENERAL]
            # engine_multithreading_mode=disabled
            # [DISPLAY]
            # shadow_type=no_shadows
            # post_processing=false
            # texture_filtering=1
            # antialias_mode=0
            # screen_shake=false
            # texture_quality=1
            alias path-of-exile="env WINEPREFIX=\"/home/tyler/.wine\" WINEDEBUG=fixme-all wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Steam/steamapps/common/Path\ of\ Exile/PathOfExileSteam.exe -gc 100 &>/dev/null & disown"
        fi
    fi
fi
