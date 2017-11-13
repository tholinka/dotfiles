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

echo -e "$CB Which video card [Nvidia, AMD, Intel, VMware/Virtualbox]$RESET"

echo -en "$C Nvidia $RESET"
read -p "$P" yn

case $yn in
    [Yy]* )
        VIDEO_CARD="nvidia-dkms nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settigns opencl-nvidia"
        VIDEO_CARD_SET="nvidia"
        NEEDS_KERNEL_HEADERS=true
        ;;
esac

if [ -z ${VIDEO_CARD_SET+x} ]; then
    echo -en "$C AMD $RESET"
    read -p "$P" yn

    case $yn in
        [Yy]* )
            VIDEO_CARD="xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau"
            VIDEO_CARD_SET="amd"
            # only needs headers for catalyst-dkms from the aur
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
            # should never need headers
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
            NEEDS_KERNEL_HEADERS=true
            ;;
    esac
fi

# only include headers if needed
if [ ! -z ${NEEDS_KERNEL_HEADERS+x} ]; then
    KERNEL="${KERNEL} ${KERNEL}-headers"
fi

sudo pacman -Sy --needed --noconfirm $PACKAGES \
$KERNEL \
$WIFI \
$VIDEO_CARD

echo -e "$CYAN Installation done $RESET"

if pacman -Q netctl &>/dev/null; then
    REMOVE_PACKAGES="$REMOVE_PACKAGES netctl"
fi

echo -en "$C Remove konqueror, dolphin, and kate $RESET"
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
        if pacman -Q kate &> /dev/null; then
            REMOVE_PACKAGES="$REMOVE_PACKAGES kate"
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

if pacman -Q open-vm-tools &>/dev/null;  then
    echo -e "$CYAN Enabling vmware vmblock fuse $RESET"
    sudo systemctl enable vmware-vmblock-fuse.service

    # also enable vmware (open-vm-tools) suid wrapper
    echo -e "$CYAN Running user-suid wrapper $RESET"
    /usr/bin/vmware-user-suid-wrapper

    echo -e "$CYAN Inserting user-suid wrapper into ~/.xinitrc, remove extras if your rerunning this script! $RESET"
    echo "/usr/bin/vmware-user-suid-wrapper" >> ~/.xinitrc
fi

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
