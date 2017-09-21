#!/bin/sh

source includes/colordefines.sh

echo -e "${GB}Installing reflector and reflector-timer${RESET}"

# install Reflector, which can rank mirrors, and reflector-timer, which does it on a timer
packages=""
if ! pacman -Q reflector &> /dev/null; then
    packages="${packages} reflector"
fi
if ! pacman -Q rsync &> /dev/null; then
    packages="${packages} rsync"
fi

if [ ! -z "$packages" ]; then
    sudo pacman -S --needed $packages
fi

packages=""
if ! pacman -Q reflector-timer &> /dev/null; then
    packages="${packages} reflector-timer"
fi

if [ ! -z "$packages" ]; then
    pacaur -S --needed --noedit $packages
fi

# echo -e "${GREEN}To change which country is put in /etc/conf.d/reflector.conf, ${BOLD}env COUNTRY=\"YOUR COUNTRY\"${RESET}${GREEN} before hand${RESET}"

echo -e "${GB}Chaning default country for reflector-timer${RESET}"

if [ -z ${COUNTRY+x} ]; then
    echo -e "${GREEN}run this command with ${BOLD}env COUNTRY="your country"${RESET}${GREEN} before the command to use something other than 'us' as your country ${RESET}"
    COUNTRY="us"
else
    COUNTRY="${COUNTRY}"
fi

echo -e "${CYAN}ignore the following, it's being tee'd to /etc/conf.d/reflector.conf${RESET}"

# update country setting
echo "COUNTRY=${COUNTRY}" | sudo tee /etc/conf.d/reflector.conf


echo -e "${GB}Enabling reflector.timer in systemctl${RESET}"

# enable / start service
sudo systemctl enable reflector.timer
sudo systemctl start reflector.timer

# manually run reflector, because timer won't trigger for ~a week

echo -e "${GB}Manually running reflector since timer won't trigger for a week${RESET}"

sudo reflector --country "${COUNTRY}" --age 12 --protocol https --protocol http --protocol ftp --protocol rsync --sort rate --save /etc/pacman.d/mirrorlist
