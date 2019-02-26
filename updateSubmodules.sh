#!/bin/bash
SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")

SettingsLoc="$FOLDERLOC/settings"
ColorLoc="$FOLDERLOC/colorschemes"

cd "$FOLDERLOC"

echo "Pulling newest of this repo ($FOLDERLOC)"
git pull

# reset all submodules
submodules="$SettingsLoc/vim/vim-plug"
submodules+=" $FOLDERLOC/zsh/config-files/zplug"
submodules+=" $ColorLoc/vertex-theme"
submodules+=" $ColorLoc/gedit-super-monokai-theme"
submodules+=" $ColorLoc/Gogh"

echo "Hard reseting submodules back to checkout point"

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

echo "Running git submodule update"

# this is aliased to gitupdatesubmodules in my zsh settings
# don't quote GIT_JOBS, we want to to split on the space
git submodule update $GIT_JOBS --recursive --remote

cd - 1>/dev/null
