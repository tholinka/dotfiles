#!/bin/bash
SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")

SettingsLoc="$FOLDERLOC/settings"
ColorLoc="$FOLDERLOC/colorschemes"

cd "$FOLDERLOC"

echo "Pulling newest of this repo ($FOLDERLOC)"
git pull

# reset all submodules
submodules=("$SettingsLoc/vim/vim-plug"
			"$FOLDERLOC/zsh/config-files/zinit"
			"$ColorLoc/vertex-theme"
			"$ColorLoc/gedit-super-monokai-theme"
			"$ColorLoc/Gogh")

echo "Hard reseting submodules back to checkout point"

for i in "${submodules[@]}"; do
	echo -n "Hard resetting $(echo $i | sed "s|$FOLDERLOC/||"): "

	cd "$i"
	git reset --hard
	cd - 1>/dev/null
done

echo "Running git submodule update"

# this is aliased to gitupdatesubmodules in my zsh settings
# don't quote GIT_JOBS, we want to to split on the space
git submodule update --jobs $(nproc --all) --recursive --remote

cd - 1>/dev/null
