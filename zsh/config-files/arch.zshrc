### originally from oh-my-zsh at https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/archlinux/archlinux.plugin.zsh
## Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
alias pacupg='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacinsd='sudo pacman -S --asdeps'
alias paclsorphans='sudo pacman -Qdt'
alias pacfileupg='sudo pacman -Fy'
alias pacfiles='pacman -Fs'

function pacrmorphans()
{
	sudo pacman -Rns $(pacman -Qtdq) $@
}

function paclistsize()
{
	expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort)) | sort -n
}

function paclist() {
	# Source: https://bbs.archlinux.org/viewtopic.php?id=93683
    LC_ALL=C pacman -Qei | \
	awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{print $2}'
}

# lists packages explicitly installed, but not in base or base-devel
function paclistnobase() {
    pacman -Qe | grep -v "$(pacman -Qg base | sed 's/base //')" | grep -v "$(pacman -Qg base-devel | sed 's/base-devel //')"
}

## pacaur is unmaintaned, but yay is more or less a drop in replacement, so just alias pacaur to yay
# if pacaur is not installed, but yay is installed
! (( $+commands[pacaur] )) && (( $+commands[yay] )) && alias pacaur="yay"

## pacaur-style aliases
if (( $+commands[pacaur] )) || (( $+aliases[pacaur] )); then
	alias paupg='pacaur -Syu --devel'
	alias pain='pacaur -S'
	alias parem='pacaur -Rns'
	alias painsd='pacaur -S --asdeps'
fi

## yay aliases
if (( $+commands[yay] )) || (( $+alaises[yay] )); then
	# set up yay to only use the aur and to always show diffs
	alias yay='yay --aur --diffmenu --answerdiff All'
fi
