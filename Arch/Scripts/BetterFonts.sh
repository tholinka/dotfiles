#!/bin/sh

# https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671
# symlink settings
sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d 2>/dev/null
sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d 2>/dev/null
sudo ln -s /etc/fonts/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d 2>/dev/null

# install fonts-meta-extened-lt from the aur
pacaur -S --needed --noedit fonts-meta-extended-lt ttf-hack ttf-ms-fonts ttf-vista-fonts

if pacman -Qtdq; then
	sudo pacman -Rs $(pacman -Qtdq) # remove orphans we created (cabextract and font-forge)
fi

# update jre to use patched fonts
echo
echo "# Do not change this unless you want to completely by-pass Arch Linux' way
# of handling Java versions and vendors. Instead, please use script 'archlinux-java'
export PATH=${PATH}:/usr/lib/jvm/default/bin

# https://wiki.archlinux.org/index.php/java#Better_font_rendering
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'" | sudo tee /etc/profile.d/jre.sh
echo
echo "Don't forget to change your font Super + N -> gear -> font"