#!/bin/sh
SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")

cd "$FOLDERLOC"

git pull

# remove package.json from vscode extensions, as it blocks pulling updates
files=$(find "Settings/vscode/extensions/"*/package.json 2>/dev/null)

if [ ${#files[@]} -ne 0 ]; then
    for i in $files; do
        echo "Removing $i"
        rm "$i"
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
