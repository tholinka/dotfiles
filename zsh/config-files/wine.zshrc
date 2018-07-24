# probably want to install some lib32 libs: lib32-cairo lib32-libcups lib32-gnutls lib32-gtk3 lib32-v4l-utils lib32-libva lib32-libxcomposite lib32-libxinerama lib32-libxslt lib32-libxml2 lib32-mpg123 lib32-lcms2 lib32-giflib lib32-libpng lib32-gnutls
# and lib32-libva-vdpau-driver if on nvidia, lib32-libva-intel-driver if using intel graphics
# also winecfg -> staging -> Enable CSMT, Enable VAAPI, Enable GTK3
# set some wine variables if not set
[[ -v WINEDEBUG ]] || export WINEDEBUG="-all"
[[ -v WINEARCH ]] || export WINEARCH="win32"
[[ -v WINEPREFIX ]] || export WINEPREFIX="$HOME/.wine"

# run this at some point, really don't need to be done on every shell tho
# it sets up a paged pool size for wine, source games require it
# wine reg add "HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Memory Management\\" /v PagedPoolSize /t REG_DWORD /d 402653184 /f
# also link system fonts:  cd ${WINEPREFIX:-~/.wine}/drive_c/windows/Fonts && for i in /usr/share/fonts/**/*.{ttf,otf}; do ln -s "$i" ; done

WINEPROGRAMFILES="$WINEPREFIX"/drive_c/"Program Files"

WINESTEAM="$WINEPROGRAMFILES"/Steam

function WINE-LAUNCHER()
{
    # split $2 into arguments
    nohup wine "$1".exe $2 1>/tmp/"$1".std.nohup 2>/tmp/"$1".error.nohup & disown 2>/dev/null
}

# see if steam is installed, assumes 32bit wine
if [ -d $WINESTEAM ]; then
    # run wine reg.exe ADD "HKEY_CURRENT_USER\Software\Wine\AppDefaults\Steam.exe" /v "Version" /t "REG_SZ" /d "winxp" /f to run steam under xp mode
    function steam-wine()
    (
        cd "$WINESTEAM"
        WINE-LAUNCHER "Steam" "-no-cef-sandbox"
    )

    WINESTEAMAPPS="$WINEPROGRAMFILES"/Steam/steamapps/common

    # see if path of exile is installed
    if [ -d  "$WINESTEAMAPPS/Path of Exile" ]; then
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
        function path-of-exile()
        (
            cd "$WINESTEAMAPPS/Path of Exile"
            WINE-LAUNCHER "PathOfExileSteam" "-gc 100"
        )
    fi

    # see if victoria 2 is installed`
    if [ -d "$WINESTEAMAPPS/Victoria 2" ]; then
        # https://appdb.winehq.org/objectManager.php?sClass=version&iId=28071&iTestingId=78680
        # https://www.reddit.com/r/paradoxplaza/comments/29f9ft/it_took_four_hours_but_i_finally_got_victoria_ii/
        # https://forum.paradoxplaza.com/forum/index.php?threads/victoria-2-demo-on-linux.490827/page-2#post-11668980
        # https://steamcommunity.com/app/42960/discussions/0/133261907142956557/
        # winetricks d3dx9d3dx9_36 d3dx9_41  d3dcompiler_43 devenum directmusic dotnet30sp1 quartz vcrun2005 vcrun2008 vcrun2010 vcrun2012 wmp9
        # delete %steam%/steamapps/common/Victoria 2/map/cache/*
        # set fullscreen=no in settings.txt
        # disable winegstreamer library in winecfg
        # wine reg.exe ADD "HKEY_CURRENT_USER\Software\Wine\AppDefaults\v2game.exe" /v "Version" /t "REG_SZ" /d "winxp" /f
        function victoria2()
        (
            # launcher crashes unless started from directory it's in
            cd "$WINESTEAMAPPS/Victoria 2"
            WINE-LAUNCHER "victoria2"
        )
    fi
fi
