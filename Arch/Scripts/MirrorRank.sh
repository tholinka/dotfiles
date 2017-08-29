#!/bin/sh

CYAN="\e[36m"
GREEN="\e[32m"
DEFAULT="\e[39m"
BOLD="\e[1m"

RESET="\e[0m"

CB="${CYAN}${BOLD}"
GB="${GREEN}${BOLD}"

echo -e "${GB}Installing reflector and reflector-timer${RESET}"

# install Reflector, which can rank mirrors, and reflector-timer, which does it on a timer
sudo pacman -S --needed reflector

pacaur -S --needed --noedit reflector-timer

# echo -e "${GREEN}To change which country is put in /etc/conf.d/reflector.conf, ${BOLD}env COUNTRY=\"YOUR COUNTRY\"${RESET}${GREEN} before hand${RESET}"

echo -e "${GB}Chaning default country for reflector-timer${RESET}"

if [ -z ${COUNTRY+x} ]; then
    echo -e "${GREEN}run this command with ${BOLD}env COUNTRY="your country"${RESET}${GREEN} before the command to use something other than 'us' as your country ${RESET}"
    country="us"
else
    prefix="${COUNTRY}"
fi

echo -e "${CYAN}ignore the following, it's being tee'd to /etc/conf.d/reflector.conf${RESET}"

# update country setting
echo COUNTRY=US | sudo tee /etc/conf.d/reflector.conf

echo -e "${GB}Enabling reflector.timer in systemctl${RESET}"

# enable / start service
sudo systemctl enable reflector.timer
sudo systemctl start reflector.timer
