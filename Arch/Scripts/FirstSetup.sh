#!/bin/sh
source includes/colordefines.sh

PACKAGES="xorg zsh git nemo chromium guake vim gufw plasma kde-applications cpupower openssh networkmanager dhclient ccache"

echo -e "$CB Enter "y" if the case applies to you $RESET"

C="$GREEN"
P="? [yN]: "


echo -en "$C WiFi $RESET"
read -p "$P" yn

case $yn in
    [Yy]* )
        WIFI="crda"
        ;;
esac

KERNEL="linux"

echo -e "$CB Choose Kernel [Linux-Zen Linux-hardened] $RESET"

echo -en "$C Linux-Zen $RESET"
read -p "$P" yn
case $yn in
    [Yy]* )
        KERNEL="${KERNEL}-zen"
        KERNEL_SET=zen
        ;;
esac

if [ -z ${KERNEL_SET+x} ]; then
    echo -en "$C Linux-Hardened $RESET"
    read -p "$P" yn
    case $yn in
        [Yy]* )
            KERNEL="${KERNEL}-hardened"
            KERNEL_SET=hardened
            ;;
    esac
fi

# also include headers
KERNEL="${KERNEL} ${KERNEL}-headers"

echo -e "$CB Which video card [Nvidia, AMD, Intel, VMware/Virtualbox]$RESET"

echo -en "$C Nvidia $RESET"
read -p "$P" yn

case $yn in
    [Yy]* )
        VIDEO_CARD="nvidia-dkms nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settigns opencl-nvidia"
        VIDEO_CARD_SET="nvidia"
        ;;
esac

if [ -z ${VIDEO_CARD_SET+x} ]; then
    echo -en "$C AMD $RESET"
    read -p "$P" yn

    case $yn in
        [Yy]* )
            VIDEO_CARD="xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau"
            VIDEO_CARD_SET="amd"
            ;;
    esac
fi

if [ -z ${VIDEO_CARD_SET+x} ]; then
    echo -en "$C Intel $RESET"
    read -p "$P" yn

    case $yn in
        [Yy]* )
            VIDEO_CARD="xf86-video-intel mesa libva-intel-driver libvdpau-va-gl"
            VIDEO_CARD_SET="intel"
            ;;
    esac
fi

if [ -z ${VIDEO_CARD_SET+x} ]; then
    echo -en "$C VirtualBox $RESET"
    read -p "$P" yn
    case $yn in
        [Yy]* )
            VIDEO_CARD="open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa-libgl libva-mesa-driver mesa-vdpau virtualbox-guest-dkms virtualbox-guest-utils gtkmm libxtst"
            VIDEO_CARD_SET="virtualbox"
            ;;
    esac
fi

sudo pacman -Sy --needed --noconfirm $PACKAGES \
$KERNEL \
$WIFI \
$VIDEO_CARD

echo -e "$CYAN Installation done $RESET"

if pacman -Q netctl &>/dev/null; then
    $REMOVE_PACKAGES="$REMOVE_PACKAGES netctl"
fi

echo -en "$C Remove konqueror and dolphin $RESET"
read -p "$P" yn
case $yn in
    [Yy]* )
        if pacman -Q konqueror &> /dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES konqueror"
        fi
        if pacman -Q dolphin &> /dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES dolphin"
        fi
        if pacman -Q dolphin-plugins &>/dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES dolphin-plugins"
        fi
esac

if [ ! -z ${KERNEL_SET+x} ]; then
    echo -en "$C Remove normal linux kernel (aka linux) $BOLD (DON'T FORGET TO CHANGE /boot ENTRY!) $RESET"
    read -p "$P" yn

    case $yn in
        [Yy]* )
            if pacman -Q linux &>/dev/null; then
                REMOVE_PACKAGES="$REMOVE_PACKAGES linux"
            fi
            if pacman -Q linux-headers &>/dev/null; then
                REMOVE_PACKAGES="$REMOVE_PACKAGES linux-headers"
            fi
    esac
fi

sudo pacman -Rns --noconfirm $REMOVE_PACKAGES


# configure packages
echo -e "$CYAN Enabling sddm $RESET"
sudo systemctl enable sddm
echo -e "$CYAN Enabling NetworkManager (please manually disable wifi menu profiles through systemctl disable netctl@<wifi-menu-profile>) $RESET"
sudo systemctl enable NetworkManager

echo -e "$CYAN Enabling vmware vmblock fuse $RESET"
echo -e "$CB If this isn't a VMware / virtualbox guest, ignore this error $RESET"
sudo systemctl enable vmware-vmblock-fuse.service

# link proc/version to arch-release, primarly for vmware
sudo ln -sf /proc/version /etc/arch-release

if pacman -Q nvidia-dkms &>/dev/null; then
    echo -e "$CYAN Setting nvidia-xconfig (with cool-bits of 12, enable fan and overclocking) $RESET"
    sudo nvidia-xconfig --cool-bits=12
fi

if [ ! -z ${WIFI+x} ]; then
    echo -en "$C What's your country? (2 letter code, e.g. United States is US, Great Briten is GB, etc.): $RESET"
    read COUNTRY
    echo -e "$CYAN setting /etc/conf.d/wireless-regdom to $COUNTRY $RESET"
    echo "WIRELESS_REGDOM=\"$COUNTRY\"" | sudo tee /etc/conf.d/wireless-regdom > /dev/null
fi

echo -e "$CYAN Setting CPUPOWER governer to Performance $RESET"

echo "governer='performance'" | sudo tee /etc/default/cpupower > /dev/null

echo -e "$CYAN Changing shell to zsh $RESET"
chsh -s /usr/bin/zsh
# change roots as well
sudo chsh -s /usr/bin/zsh

echo -e "$CYAN Setting root to use user zsh config $RESET"
echo "export ZSH_CONFIG=\"$HOME/.zsh-config\"
echo -e \"\e[36mHit \\\"y\\\" to accept the warning\e[39m\"
source $HOME/.zsh-config/zshrc.zshrc" | sudo tee /root/.zshrc >/dev/null
echo "source $HOME/.zprofile" | sudo tee /root/.zprofile >/dev/null
