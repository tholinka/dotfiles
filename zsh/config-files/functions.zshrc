FUNCTIONS_FILE_LOC="${(%):-%N}" # hacky workaround to replace bash's export

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

function gitsubdirs()
{
    command ls -R --directory --color=never */.git | sed 's/\/.git//'
}

function gitall()
{
    git_step . pull
    gitsubdirs |
     xargs -P10 -I{} zsh -c "source $FUNCTIONS_FILE_LOC ; git_step {} pull"; # hacky workaround to get around the fact that zsh doesn't have export -f
}

function gitcheckall()
{
    if [ -z "$1" ]; then
        branch="master"
    else
        branch="$1"
    fi

    git_step . checkout $branch
    gitsubdirs |
     xargs -P10 -I{} zsh -c "source $FUNCTIONS_FILE_LOC ; git_step {} checkout $branch"; # see gitall for hacky workaround reason
}

# grep wrapper (even though it's called findhere) that does grep --include "..." --exclude "..." -Rnwi . -e "[pattern]" in an easy function of findhere [pattern] [exclude] [include]
function findhere()
{
    # echo "findhere pattern exclude include e.g. findhere \"hello world\" \"*.o\" \"*.{c,h}\""
    if [ -z "$2" ]; then
        exclude=""
    else
        exclude="--exclude=\"$2\ "
    fi

    if [ -z "$3" ]; then
        include=""
    else
        include="--include=$3"
    fi

    echo "searching for \"$1\" with include of \"$2\" and exclude of \"$3\""

    grep $include $exclude -Rnwi . -e $1 || echo "nothing found"
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

if type wine &> /dev/null ; then
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

# kill dhcpcd and restart it to get a new ip from my school's crappy af network
function reset-dhcpcd()
{
    sudo dhcpcd -k
    sudo dhcpcd
}

# from https://stackoverflow.com/a/14728706
function git-gc-all()
{
    git reflog expire --expire-unreachable=now --all

    git -c gc.reflogExpire=0 -c gc.reflogExpireUnreachable=0 -c gc.rerereresolved=0 \
    -c gc.rerereunresolved=0 -c gc.pruneExpire=now gc "$@"
}
