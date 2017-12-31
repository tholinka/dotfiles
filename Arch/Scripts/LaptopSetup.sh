#!/bin/sh

source includes/colordefines.sh

if ! type trizen &>/dev/null; then
    echo -e "${GB}NO trizen, use \"AurSetup\" script first! ${RESET}"
    return;
fi

echo -e "${GB}Installing laptop-mode-tools + optional deps ${RESET}"

trizen -S --needed --noconfirm laptop-mode-tools
sudo pacman -S --asdeps --needed --noconfirm acpid bluez-utils hdparm sdparm ethtool wireless_tools xorg-xset python2-pyside

echo -e "${GB}Enabling laptop mode service in systemctl ${RESET}"
sudo systemctl enable laptop-mode.service

echo -e "${CB}Done, edit /etc/laptop-mode/laptop-mode.conf and /etc/laptop-mode/conf.d/* to liking ${RESET}"
echo -e "${CYAN} of note is /etc/laptop-mode/conf.d/auto-hibernate.conf, which can be enabled by setting ENABLE_AUTO_HIBERNATE=1 ${RESET}"