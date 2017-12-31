#!/bin/sh


# libc++ and therefor discord requires an import of a key
gpg --recv-keys 11E521D646982372EB577A1F8F0871F202119294

# install a bunch of packages
# in order of each line:
# spotify + deps for local play
# skype + other instant messages client
# replace vi with vim
# google drive sync
# discord + font for discord icons
# update systemd-boot on pacman update, install "missing" mkinitcpio firmware
# install chromium extras
# colorize make output (needs alias's in ~/.zsh-config/aliases.zshrc)

trizen -S --needed --noconfirm \
spotify zenity ffmpeg0.10 \
rambox \
vi-vim-symlink \
insync \
betterdiscord ttf-symbola \
systemd-boot-pacman-hook wd719x-firmware aic94xx-firmware \
pepper-flash chromium-widevine \
colormake \
visual-studio-code-bin

# remove desktop file electron adds -.-
rm "$HOME/.config/autostart/electron.desktop"

# add rambox autostart
cp "/usr/share/applications/rambox.desktop" "$HOME/.config/autostart"