#!/bin/sh

SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")
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
    mkdir ~/.steam
fi
if [ ! -e ~/.steam/steam ]; then
    ln -sf ~/.steam/steam ~/.local/share/Steam/
fi
if [ ! -d ~/.local/share/Steam ]; then
    mkdir ~/.local/share/Steam
fi
if [ ! -d ~/.local/share/Steam/skins ]; then
    mkdir ~/.local/share/Steam/skins
fi
### end .local section ###

### couple random folders ###
if [ -d ~/.vim ]; then
    rm ~/.vim
fi


## symlinks
### .config section ###
ln -sf "$FOLDERLOC/config/Code/User/keybinds.json" ~/.config/Code/User/
ln -sf "$FOLDERLOC/config/Code/User/settings.json" ~/.config/Code/User/

ln -sf "$FOLDERLOC/config/QtProject/qtcreator/styles/monokai_tyler.xml" ~/.config/QtProject/qtcreator/styles/

ln -sf "$FOLDERLOC/config/zathura/zathurarc" ~/.config/zathura/

ln -sf "$FOLDERLOC/vim/colors/monokai.vim" ~/.config/nvim/colors
ln -sf "$FOLDERLOC/vim/vim-runtime/" ~/.config/nvim/vim-runtime
ln -sf "$FOLDERLOC/vim/vimrc" ~/.config/nvim/init.vim

# link both chrome and chromium against flags, these might be an arch only things ?
ln -sf "$FOLDERLOC/config/chromium-flags.conf" ~/.config/chromium-flags.conf
ln -sf "$FOLDERLOC/config/chromium-flags.conf" ~/.config/chrome-flags.conf
### end of .config ###
### .local section ###
ln -sf "$FOLDERLOC/local/share/konsole/monokai.colorscheme" ~/.local/share/konsole/
ln -sf "$FOLDERLOC/local/share/konsole/Shell.profile" ~/.local/share/konsole/Shell.profile

## have to copy, steam can't do symlinks for skins
cp -r "$FOLDERLOC/local/share/Steam/skins/Metro 4.2.4" ~/.steam/steam/skins/
### end of .local ###
### couple random folders ###
ln -sf "$FOLDERLOC/vim" ~/.vim
# replace ~/.vimrc with a link to ~/.vim
echo "source ~/.vim/vimrc" > ~/.vimrc
# pull in vim runtime link vim-runtime as it expects
ln -sf "$FOLDERLOC/vim/vim-runtime" ~/.vim_runtime

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
