# Installing Part 4 - After restart

> This assumes that Part 3 is already done and you restarted.    And that succeeded.

1. Login as root
1. add a new user: ```useradd -m -g users -G wheel,storage,power -s /bin/bash 'username'```
    * set a password for this user, passwd 'username'
1. Add the ```wheel``` group to the sudoers file, run ```EDITOR=vim visudo``` and find the line that says ```Uncomment to allow members of group wheel to execute any command```, uncomment that line
1. ```exit``` and login to your user account
1. ```ping google.com```, if you don't have a connection, repeat process from step 1
1. Time to install a bunch of packages ```pacman -Sy --needed --noconfirm xorg zsh git nemo chromium guake vim gufw plasma kde-applications cpupower openssh networkmanager dhclient ccache```
    * add ```crda``` if you have wifi
    * add a different linux kernel, either ```linux-zen``` or ```linux-hardened```, also include the ```[kernelname]-headers``` package
    * ```linux-zen``` is generally faster, ```linux-hardened``` is a bit more secure
    * Uninstall the normal linux kernel to free up space in /boot, ```pacman -Rns linux```
    * Video Card Drivers:
        * NVIDIA: add ```nvidia nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settings opencl-nvidia``` (if your using linux-zen or linux-hardened, use ```nvidia-dkms linux-[kernel name]-headers``` instead of ```nvidia```, to make the dkms modules for those kernels)
        * AMD: add ```xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau```
        * INTEL: add ```xf86-video-intel mesa libva-intel-driver libvdpau-va-gl```
        * Virtualbox: add ```open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa-libgl libva-mesa-driver mesa-vdpau```
            * Guests also add ```virtualbox-guest-dkms virtualbox-guest-utils gtkmm libxtst```
            * Hosts also add ```virtualbox-host-dkms```
1. Remove unneeded packages using ```pacman -Rns [package]```
    * ```netctl``` as network manager replaces it
    * ```konqueror dolphin```  optionally, as chromium and nemo replace them
1. configure installed packages
    1. enable sddm, ```systemctl enable sddm```
    1. enable networkmanager, ```systemctl enable NetworkManager```, and disable netctl if needed, ```netctl disable <wifi-menu profile>```, ```systemctl disable netctl@<wifi-menu profile>```
    1. set crda regdom, edit ```/etc/conf.d/wireless-regdom``` and uncomment your country
    1. switch to performance cpu govener, edit ```/etc/default/cpupower``` and uncomment ```governor='``` and replace what is there with ```performance```, and then run ```systemctl enable cpupower```
    1. switch to zsh, ```chsh -s /usr/bin/zsh```
    1. nvidia users, run ```sudo nvidia-xconfig``` to get a nvidia-specific x config, and you can enable overclocking by instead doing ```sudo nvidia-xconfig --cool-bits=12``` see [here](https://wiki.archlinux.org/index.php/NVIDIA/Tips_and_tricks#Enabling_overclocking) for full options
    1. switch to new kernel
        * edit ```/boot/loader/loader.conf``` to default to linux-[kernel name], e.g. linux-zen
        * copy ```/boot/loader/config/arch.conf``` to arch-[kernel name].conf
        * add ```-kernelname``` to the vmlinuz and initramfs lines of the config
    1. Virtualbox setup, ```systemctl enable vmware-vmblock-fuse.service```
        * update kernel info ```ln -s /proc/version /etc/arch-release```
1. Reconfigure your boot options to be quieter / faster
    * Add ```rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3``` to the end of the options line of ```/boot/loader/config```.    If you would like to enable hibernate, add ```resume=PARTUUID=[your swap partition]```.
    * For a marginal boot speed increase, edit ```/etc/fstab``` and remove the ```rw``` line from your ```/``` partition, as systemd will now do that instead
1. reboot again, you should reboot into a login menu.
    * for wifi, open up Settings -> Network and use that menu now
1. Set up pacman config, edit ```/etc/pacman.conf``` and:
    * Enable multilib: find [multilib] and uncomment it and the line below it
    * Enable Color: Uncomment the word "Color", optinally "TotalDownload" as well
1. customize makepkg: edit ```/etc/makepkg.conf```
    * Replace the following contents of ```CFLAGS```: ```-march=x86-64 -mtune=generic -O2``` with ```-march=native -mtune=native -O3```
    * Replace the contents of ```CXXFLAGS``` with ```${CFLAGS}```
    * Enable parrellel make: Uncomment ```MAKEFLAGS``` and set equal to ```-j$(nproc)```
    * Enable ccache: change ```BUILDENV``` to ```fakeroot !distcc color ccache check !sign```
1. run ```pacman -Sy``` to grab the multilib stuff
1. git clone this repository into something like .settings-git
1. run AurSetup.sh to install pacaur
1. Continue to Part 5, misc setup
