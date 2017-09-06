#!/bin/sh
CYAN="\e[36m"
DEFAULT="\e[39m"
# get pacaur if it's not installed
if ! which pacaur &> /dev/null; then
	# need cower
	if ! which cower &> /dev/null; then
		echo -e "${CYAN}Installing cower, pacaur needs it${DEFAULT}"
		git clone https://aur.archlinux.org/cower.git
		cd cower
		# need the keys or the build will fail, though this server is down sometimes, as such we'll just work either way, but we'll try to use keys
		echo "Getting build keys..."
		if ! gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53; then
			skipkey="--skippgpcheck"
		fi
		makepkg -si $skipkey
		cd -
		rm cower -rf
	fi

	if which cower &>/dev/null; then
		echo -e "${CYAN}Install pacaur${DEFAULT}"
		git clone https://aur.archlinux.org/pacaur.git
		cd pacaur
		makepkg -si
		cd -
		rm pacaur -rf

	else
		echo "Failed to install cower"
	fi
fi
