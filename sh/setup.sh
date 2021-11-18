#!/bin/bash
# if on mac, make sure you `brew install coreutils`
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" # mac workaround, since we don't have ~/.profile setup yet to fix this
SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")
# create symblink to config-files and ~/.sh-config
## remove existing one so that a symlink isn't created at ~/.sh-config/.sh-config
if [ -e ~/.sh-config ]; then
	echo "Removing ~/.sh-config symlink"
	rm ~/.sh-config # should be a symlink
fi

echo "Creating ~/.sh-config symlink"
ln -s "$FOLDERLOC/config-files" ~/.sh-config

# replace ~/.profile with a pointer here
echo "Replacing ~/.profile with a pointer to ~/.sh-config/profile.profile"
echo "source ~/.sh-config/profile.profile" >~/.profile

# replace ~/.bash_profile with a pointer here
echo "Replacing ~/.bash_profile with a pointer to ~/.sh-config/profile.profile"
echo "source ~/.sh-config/profile.profile" >~/.bash_profile

# replace ~/.bashrc and ~/.bash_aliases with a pointer here
echo "Replacing ~/.bashrc with a pointer to ~/.sh-config/bashrc.bashrc"
echo "source ~/.sh-config/bashrc.bashrc" >~/.bashrc
echo "Replacing ~/.bash_aliases with a pointer to ~/.sh-config/aliases.bashrc"
echo "source ~/.sh-config/aliases.bashrc" >~/.bash_aliases
