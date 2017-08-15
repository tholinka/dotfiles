#!/bin/sh

# install a bunch of packages
# in order of each line:
# spotify + deps for local play
# replace vi with vim
# google drive sync
# discord + font for discord icons
# update systemd-boot on pacman update

pacaur -S --needed --noedit --noconfirm \
spotify zenity ffmpeg0.10 \
skypeforlinux-bin \
vi-vim-symlink \
insync \
betterdiscord ttf-symbola \
systemd-boot-pacman-hook
