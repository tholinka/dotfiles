#!/bin/bash
SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")

SettingsLoc="$FOLDERLOC/Settings"

cd "$FOLDERLOC"

git pull

# reset all submodules
submodules=$(echo "$SettingsLoc/vscode/extensions/"*)
submodules+=" $SettingsLoc/vim/vim-runtime"
submodules+=" $FOLDERLOC/zsh/config-files/zplug"

if [ ${#submodules[@]} -ne 0 ]; then
    for i in $submodules; do
        echo -n "Hard resetting $(echo $i | sed "s|$FOLDERLOC/||"): "

        cd "$i"
        git reset --hard
        cd - 1>/dev/null
    done
fi

# see if update can be done in parellel (--jobs) (added in git version 2.9.0)

if [ $(printf "$(git --version | sed "s/git version //")\n2.9.0" | sort -V | head -n1) = "2.9.0" ]; then
    # 2.9.0 is a newer string than git --version, so it should have it
    GIT_JOBS="--jobs $(nproc --all)"
fi

# this is aliased to gitupdatesubmodules in my zsh settings
# don't quote GIT_JOBS, we want to to split on the space
git submodule update $GIT_JOBS --recursive --remote

cd - 1>/dev/null
