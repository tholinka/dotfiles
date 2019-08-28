#!/bin/sh
SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")

# remove existing link if it exists
if [ -d ~/.vscode ]; then
	rm ~/.vscode
fi

### .config section ###
if [ ! -d ~/.config ]; then
	mkdir ~/.config
fi

if [ ! -d ~/.config/Code ]; then
	mkdir ~/.config/Code
fi
if [ ! -d ~/.config/Code/User ]; then
	mkdir ~/.config/Code/User
fi

if [ ! -d ~/.config/QtProject ]; then
	mkdir ~/.config/QtProject
fi
if [ ! -d ~/.config/QtProject/qtcreator ]; then
	mkdir ~/.config/QtProject/qtcreator
fi
if [ ! -d ~/.config/QtProject/qtcreator/styles ]; then
	mkdir ~/.config/QtProject/qtcreator/styles
fi

if [ ! -d ~/.config/zathura ]; then
	mkdir ~/.config/zathura
fi
if [ ! -d ~/.config/nvim ]; then
	mkdir ~/.config/nvim
fi
if [ ! -d ~/.config/nvim/colors ]; then
	mkdir ~/.config/nvim/colors
fi

### end .config section ###

### .local section ###
if [ ! -d ~/.local ]; then
	mkdir ~/.local
fi

if [ ! -d ~/.local/share ]; then
	mkdir ~/.local/share
fi

if [ ! -d ~/.local/share/konsole ]; then
	mkdir ~/.local/share/konsole
fi

# see if ~/.steam exists
if [ ! -d ~/.steam ]; then
	NO_STEAM=true
fi
### end .local section ###

### see if gnupg exists
if [ ! -d ~/.gnupg ]; then
	mkdir ~/.gnupg
fi
### end gnupg

### remove ~/.vim if it exists ###
if [ -d ~/.vim ]; then
	rm ~/.vim
fi

## symlinks
### .config section ###
ln -sf "$FOLDERLOC/config/Code/User/keybinds.json" ~/.config/Code/User/
ln -sf "$FOLDERLOC/config/Code/User/settings.json" ~/.config/Code/User/

ln -sf "$FOLDERLOC/config/QtProject/qtcreator/styles/monokai_tyler.xml" ~/.config/QtProject/qtcreator/styles/

ln -sf "$FOLDERLOC/config/zathura/zathurarc" ~/.config/zathura/

ln -sf "$FOLDERLOC/vim/autoload/" ~/.config/nvim/autoload
ln -sf "$FOLDERLOC/vim/nvim.vimrc" ~/.config/nvim/init.vim

# link both chrome and chromium against flags, these might be an arch only things ?
ln -sf "$FOLDERLOC/config/chromium-flags.conf" ~/.config/chromium-flags.conf
ln -sf "$FOLDERLOC/config/chromium-flags.conf" ~/.config/chrome-flags.conf
### end of .config ###
### .local section ###
ln -sf "$FOLDERLOC/local/share/konsole/monokai.colorscheme" ~/.local/share/konsole/
ln -sf "$FOLDERLOC/local/share/konsole/Shell.profile" ~/.local/share/konsole/Shell.profile

## have to copy, steam can't do symlinks for skins
if [ -z ${NO_STEAM+x} ]; then
	cp -r "$FOLDERLOC/local/share/Steam/skins/Metro 4.2.4" ~/.steam/steam/skins/
fi
### end of .local ###

### .gnupg ###
ln -sf "$FOLDERLOC/gnupg/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
### end .gnupg

### link vim's folder ###
ln -sf "$FOLDERLOC/vim" ~/.vim
# replace ~/.vimrc with a link to ~/.vim
echo "source ~/.vim/vim.vimrc" > ~/.vimrc

ln -sf "$FOLDERLOC/vscode" ~/.vscode

ln -sf "$FOLDERLOC/astylerc" ~/.astylerc

ln -sf "$FOLDERLOC/gitgeneralconfig" ~/.gitgeneralconfig


# copy editorconfig, gitattributes, and gitignore
cp $FOLDERLOC/editorconfig ~/.editorconfig
cp $FOLDERLOC/gitattributes ~/.gitattributes
cp $FOLDERLOC/gitignore ~/.gitignore

echo "[include]
	path = ~/.gitgeneralconfig" >> ~/.gitconfig
echo "Included link to .gitgeneralconfig in ~/.gitconfig, make sure there aren't to many links of that in there"

echo;

#echo "Also tell git about your gpg key: \"gpg --list-secret-keys --keyid-format LONG\" to get the key and \"git config --global user.signingkey [key from previous command]\" to have git use it"
#echo "You may also need to restart the agent (probably not, but maybe): \"gpg--connect-agent reloadagent /bye\""
