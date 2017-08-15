#!/bin/sh

# install a bunch of packages
# in order of each line:
# wine
# vlc + ui
# libreoffice
# java + some optionals
# codecs
# better ls

sudo pacman -S --needed --noconfirm \
wine-staging \
vlc qt4 \
libreoffice-fresh \
jre8-openjdk alsa-lib icedtea-web java-openjfx \
gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly flac \
exa