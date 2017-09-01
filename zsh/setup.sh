#/bin/sh

echo "RUN THIS FROM THE FOLDER IT IS SITTING IN OR IT WILL BREAK, rerun it if you move this folder"

# create symblink to config-files and ~/.zsh-config
if [ -e ~/.zsh-config ]; then
    rm ~/.zsh-config # should be a symlink
fi

ln -s "$PWD/config-files" ~/.zsh-config

# replace ~/.zshrc with a pointer here
echo "source ~/.zsh-config/zshrc.zshrc" > ~/.zshrc

# clone in oh-my-zsh
if [ ! -e ~/.zsh-config/oh-my-zsh/oh-my-zsh.sh ]; then
    # not cloned ?
    if [ -d ~/.zsh-config/oh-my-zsh ]; then
        rm ~/.zsh-config/oh-my-zsh -r
    fi

    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.zsh-config/oh-my-zsh > /dev/null
else
    # just update it
    git -C ~/.zsh-config/oh-my-zsh pull > /dev/null
fi

if ! pacman -Q powerline-fonts &> /dev/null; then
    echo "Need powerline fonts for theme!"
    sudo pacman -S powerline-fonts
fi
