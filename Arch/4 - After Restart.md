# Installing Part 4 - After restart
###### This assumes that Part 3 is already done and you restarted.  And that succeeded.
1) Login as root
2) add a new user: ```useradd -m -g users -G wheel,storage,power -s /bin/bash 'username'```
	* set a password for this user, passwd 'username'
3) Add the ```wheel``` group to the sudoers file, run ```EDITOR=vim visudo``` and find the line that says ```Uncomment to allow members of group wheel to execute any command```, uncomment that line
4) ```exit``` and login to your user account
5) ```ping google.com```, if you don't have a connection, repeat process from step 1
6) Time to install a bunch of packages ```pacman -Sy --needed --noconfirm xorg zsh git budgie-desktop gdm nemo chromium gnome-terminal guake vim gufw gnome gnome-backgrounds gnome-control-center gnome-screensaver gnome-keyring gnome-tweak-tool cpupower```
	* add ```crda networkmanager dhclient``` if you have wifi, and remove ```netctl``` (networkmanager replaces it)
	* add a different linux kernel, either ```linux-zen``` or ```linux-hardened```
		* ```linux-zen``` is generally faster, ```linux-hardened``` is a bit more secure
		* Uninstall the normal linux kernel to free up space in /boot, ```pacman -Rns linux```
	* Video Card Drivers:
		* NVIDIA: add ```nvidia nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settings opencl-nvidia``` (if your using linux-zen or linux-hardened, use ```nvidia-dkms linux-[kernel name]-headers``` instead of ```nvidia```, to make the dkms modules for those kernels)
		* AMD: add ```xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau```
		* INTEL: add ```xf86-video-intel mesa libva-intel-driver libvdpau-va-gl```
		* Virtualbox: add ```open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa-libgl libva-mesa-driver mesa-vdpau```
		  * Guests also add ```virtualbox-guest-dkms virtualbox-guest-utils```
		  * Hosts also add ```virtualbox-host-dkms```
7) configure installed packages
    1) enable gdm, ```systemctl enable gdm```
    2) enable networkmanager, ```systemctl enable NetworkManager```, and disable netctl if needed, ```netctl disable <wifi-menu profile>```, ```systemctl disable netctl@<wifi-menu profile>```
    3) set crda regdom, edit ```/etc/conf.d/wireless-regdom``` and uncomment your country
    3) switch to performance cpu govener, edit ```/etc/default/cpupower``` and uncomment ```governor='``` and replace what is there with ```performance```, and then run ```systemctl enable cpupower```
    2) switch to zsh, ```chsh -s /usr/bin/zsh```
    3) nvidia users, run ```sudo nvidia-xconfig``` to get a nvidia-specific x config, and you can enable overclocking by instead doing ```sudo nvidia-xconfig --cool-bits=12``` see [here](https://wiki.archlinux.org/index.php/NVIDIA/Tips_and_tricks#Enabling_overclocking) for full options
    3) switch to new kernel
    	* edit ```/boot/loader/loader.conf``` to default to linux-[kernel name], e.g. linux-zen
    	* copy ```/boot/loader/config/arch.conf``` to arch-[kernel name].conf
    	* add ```-kernelname``` to the vmlinuz and initramfs lines of the config
    4) Virtualbox setup, ```systemctl enable vmware-vmblock-fuse.service```
        * update kernel info ```ln -s /proc/version etc/arch-release```
8) Reconfigure your boot options to be quieter / faster
	* Add ```rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3``` to the end of the options line of ```/boot/loader/config```.  If you would like to enable hibernate, add ```resume=PARTUUID=[your swap partition]```.
	* For a marginal boot speed increase, edit ```/etc/fstab``` and remove the ```rw``` line from your ```/``` partition, as systemd will now do that instead
9) reboot again, you should reboot into a desktop.  From the gear icon next to the password, select ```gnome``` and then select ```budgie-desktop``` again.
	* for wifi, open up Settings -> Network and use that menu now
10) Enable multilib: edit ```/etc/pacman.conf```, find [multilib] and uncomment it and the line below it
11) customize makepkg: edit ```/etc/makepkg.conf```
	* replace the following portion of ```CFLAGS```: ```-march=x86-64 -mtune=generic -O2``` with ```-march=native -mtune=native -O3```
	* replace ```CXXFLAGS``` with ```${CFLAGS}```
12) run ```pacman -Sy``` to grab the multilib stuff
10) git clone this repository into something like .settings-git
11) run AurSetup.sh to install pacaur
10) Continue to Part 5, misc setup
