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

## pacaur is unmaintaned, but paru is more or less a drop in replacement, so just alias pacaur to paru
# if pacaur is not installed, but paru is installed
! (( $+commands[pacaur] )) && (( $+commands[paru] )) && alias pacaur="paru"

## pacaur-style aliases
if (( $+commands[pacaur] )) || (( $+aliases[pacaur] )); then
	alias paupg='pacaur -Syu --devel'
	alias pain='pacaur -S'
	alias parem='pacaur -Rns'
	alias painsd='pacaur -S --asdeps'
fi

## paru aliases
if (( $+commands[paru] )) || (( $+alaises[paru] )); then
	# set up paru to only use the aur
	alias paru='paru --aur'
fi
