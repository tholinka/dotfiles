#!/bin/sh

echo "RUN THIS FROM THE DIRECTORY IT IS IN, OR THINGS WILL BREAK"

# make a bunch of symlinks



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
if [ -L ~/.steam/steam ]; then
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

if [ ! -d ~/.vscode ]; then
    mkdir ~/.vscode
fi


## symlinks
### .config section ###
ln -sf "$PWD/config/Code/User/keybinds.json" ~/.config/Code/User/
ln -sf "$PWD/config/Code/User/settings.json" ~/.config/Code/User/

ln -sf "$PWD/config/QtProject/qtcreator/styles/monokai_tyler.xml" ~/.config/QtProject/qtcreator/styles/

ln -sf "$PWD/config/zathura/zathurarc" ~/.config/zathura/

# link both chrome and chromium against flags, these might be an arch only things ?
ln -sf "$PWD/config/chromium-flags.conf" ~/.config/chromium-flags.conf
ln -sf "$PWD/config/chromium-flags.conf" ~/.config/chrome-flags.conf
### end of .config ###
### .local section ###
ln -sf "$PWD/local/share/konsole/monokai.colorscheme" ~/.local/share/konsole/
ln -sf "$PWD/local/share/konsole/Shell.profile" ~/.local/share/konsole/Shell.profile

## have to copy, steam can't do symlinks for skins
cp -r "$PWD/local/share/Steam/skins/Metro 4.2.4" ~/.steam/steam/skins/
### end of .local ###
### couple random folders ###
ln -sf "$PWD/vim" ~/.vim
# replace ~/.vimrc with a link to ~/.vim
echo "source ~/.vim/vimrc" > ~/.vimrc
# pull in vim runtime link vim-runtime as it expects
ln -sf "$PWD/vim/vim-runtime" ~/.vim_runtime

ln -sf "$PWD/vscode/settings.json" ~/.vscode/

ln -sf "$PWD/astylerc" ~/.astylerc
ln -sf "$PWD/gitgeneralconfig" ~/.gitgeneralconfig
echo "[include]
    path = ~/.gitgeneralconfig" >> ~/.gitconfig
echo "Included link to .gitgeneralconfig in ~/.gitconfig, make sure there aren't to many links of that in there"