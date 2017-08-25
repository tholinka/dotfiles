#!/bin/sh

# install a bunch of packages
# in order of each line:
# wine
# vlc + ui
# libreoffice
# java + some optionals
# codecs
# better ls
# nemo extentions
# gedit
# eye of gnome

sudo pacman -S --needed --noconfirm \
wine-staging wine-mono wine_gecko winetricks \
vlc qt4 \
libreoffice-fresh \
jre8-openjdk alsa-lib icedtea-web java-openjfx \
gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly flac \
exa \
nemo-fileroller p7zip unrar nemo-preview nemo-seahorse nemo-share \
gedit \
eog eog-plugins