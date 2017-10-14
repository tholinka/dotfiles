SCRIPTLOC=$(readlink -f "$0")
FOLDERLOC=$(dirname "$SCRIPTLOC")
# create symblink to config-files and ~/.zsh-config
## remove existing one so that a symlink isn't created at ~/.zsh-config/.zsh-config
if [ -e ~/.zsh-config ]; then
    rm ~/.zsh-config # should be a symlink
fi

ln -s "$FOLDERLOC/config-files" ~/.zsh-config

# replace ~/.zshrc with a pointer here
echo "source ~/.zsh-config/zshrc.zshrc" > ~/.zshrc

# replace ~/.zprofile with a pointer here
echo "source ~/.zsh-config/zprofile.zshrc" > ~/.zprofile

# if no pacman remind to install powerline fonts for theme
if type pacman &>/dev/null; then
    # otherwise see if pacman has them installed
    if ! pacman -Q powerline-fonts &> /dev/null; then
        echo "Need powerline fonts for theme!"
        sudo pacman -S powerline-fonts
    fi
else
    echo "Remember to install powerline fonts for theme!"
fi
