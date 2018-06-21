# some pacman helpers
if type pacman &>/dev/null ; then
    function pacrmorphans()
    {
        sudo pacman -Rnsc $(pacman -Qdtq)
    }
    function paclistsize()
    {
        expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort)) | sort -n
    }
fi


### originally from oh-my-zsh at https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/archlinux/archlinux.plugin.zsh
## Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
if type pacman &>/dev/null ; then
    alias pacupg='sudo pacman -Syu'
    alias pacin='sudo pacman -S'
    alias pacins='sudo pacman -U'
    alias pacre='sudo pacman -R'
    alias pacrem='sudo pacman -Rns'
    alias pacrep='pacman -Si'
    alias pacreps='pacman -Ss'
    alias pacloc='pacman -Qi'
    alias paclocs='pacman -Qs'
    alias pacinsd='sudo pacman -S --asdeps'
    alias pacmir='sudo pacman -Syy'
    alias paclsorphans='sudo pacman -Qdt'
    alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'
    alias pacfileupg='sudo pacman -Fy'
    alias pacfiles='pacman tFs'
fi
## pacaur is unmaintaned, but yay and trizen are more or less a drop in replacement, so just alias pacaur to one of them (yay preferred)
# if pacaur is not installed, but yay is installed
if ! tpye pacaur &>/dev/null && type yay &>/dev/null; then
    alias pacaur="yay"
# if pacaur is not installed, but trizen is installed
elif ! type pacaur &>/dev/null && type trizen &>/dev/null; then
    alias pacaur="trizen"
fi

## pacaur aliases, since pacaur is umaintaned, these should get removed at some point, but they're more ingrained in memory
if type pacaur &>/dev/null; then
    alias paupg='pacaur -Syu'
    alias pasu='pacaur -Syu --noconfirm'
    alias pain='pacaur -S'
    alias pains='pacaur -U'
    alias pare='pacaur -R'
    alias parem='pacaur -Rns'
    alias parep='pacaur -Si'
    alias pareps='pacaur -Ss'
    alias paloc='pacaur -Qi'
    alias palocs='pacaur -Qs'
    alias palst='pacaur -Qe'
    alias paorph='pacaur -Qtd'
    alias painsd='pacaur -S --asdeps'
    alias pamir='pacaur -Syy'
fi

## trizen aliases
if type trizen &>/dev/null; then
    alias trupg='trizen -Syu'
    alias trsu='trizen -Syu --noconfirm'
    alias trin='trizen -S'
    alias trins='trizen -U'
    alias trre='trizen -R'
    alias trrem='trizen -Rns'
    alias trrep='trizen -Si'
    alias trreps='trizen -Ss'
    alias trloc='trizen -Qi'
    alias trlocs='trizen -Qs'
    alias trlst='trizen -Qe'
    alias trorph='trizen -Qtd'
    alias trinsd='trizen -S --asdeps'
    alias trmir='trizen -Syy'
fi

## yay aliases
if type yay &>/dev/null; then
    # set up yay to only use the aur
    alias yay='yay --aur'

    alias yaupg='yay -Syu'
    alias yasu='yay -Syu --noconfirm'
    alias yain='yay -S'
    alias yains='yay -U'
    alias yare='yay -R'
    alias yarem='yay -Rns'
    alias yarep='yay -Si'
    alias yareps='yay -Ss'
    alias yaloc='yay -Qi'
    alias yalocs='yay -Qs'
    alias yalst='yay -Qe'
    alias yaorph='yay -Qtd'
    alias yainsd='yay -S --asdeps'
    alias yamir='yay -Syy'
fi

paclist() {
  # Source: https://bbs.archlinux.org/viewtopic.php?id=93683
  LC_ALL=C pacman -Qei $(pacman -Qu | cut -d " " -f 1) | \
    awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{print $2}'
}

pacmanallkeys() {
  emulate -L zsh
  curl -s https://www.archlinux.org/people/{developers,trustedusers}/ | \
    awk -F\" '(/pgp.mit.edu/) { sub(/.*search=0x/,""); print $1}' | \
    xargs sudo pacman-key --recv-keys
}

pacmansignkeys() {
  emulate -L zsh
  for key in $*; do
    sudo pacman-key --recv-keys $key
    sudo pacman-key --lsign-key $key
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key $key
  done
}
