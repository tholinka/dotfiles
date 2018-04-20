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

# this is aliased to gitupdatesubmodules in my zsh settings
git submodule update --jobs 4 --recursive --remote

cd -
