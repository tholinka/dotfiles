# Installing Part 3 - Pacstrap and Chroot
###### This assumes that Part 2 is already done, and your sitting on the command prompt with your partitions mount to /mnt.

1) run ```pacstrap /mnt base base-devel```.
2) Make fstab with ```genfstab -U /mnt >> /mnt/etc/fstab```
3) Chroot into the new install, ```arch-chroot /mnt /bin/bash```
4) Uncomment ```en_US.UTF-8 UTF-8``` (or your locale, you can uncomment multiple) in ```/etc/locale.gen``` and then run ```locale-gen``` and then run ```echo LANG=en_US.UTF-8 > /etc/locale.conf``` (replace en_US.UTF-8 with your locale).
	* if you set your keyboard earlier (to anything non-us), make those changes perminent in by editing ```/etc/vconsole.conf``` to include ```KEYMAP=[keymap setting]``` and, after a newline ```FONT=[font setting]```
5) Select a timezone, ```tzselect``` to find the timezone to us, and then ```ln -s /usr/share/zoneinfo/[zone]/[subzone] /etc/localtime```, you may need to ```rm /etc/localtime``` first
6) Set your hardware clock, ```hwclock --systohc --utc```, this will "break" windows time if you are dual booting, see [this](https://wiki.archlinux.org/index.php/Time#UTC_in_Windows) to "fix" it
7) IF you used LVM in step 2
	* If you are using systemd (all new Arch installs are), replace ``udev`` with ```systemd``` and add ```sd-lvm2``` before ```filesystems``` on the HOOKS= line of ```/etc/mkinitcpio.conf```
	* If you are using non-systemd init (for some reason), add ```lvm2``` to the above file
	* Then run ```mkinitcpio -p linux```
8) Time to install some packages so we can boot directly to graphics and for ease  ```pacman -S --needed --noconfirm xorg zsh git budgie-desktop gdm nemo chromium gnome-terminal guake vim gufw```
	* add ```crda networkmanager dhclient``` if you have wifi
	* add ```intel-ucode``` if you have an intel processor
	* add a different linux kernel, either ```linux-zen``` or ```linux-hardened```
		* ```linux-zen``` is generally faster, ```linux-hardened``` is a bit more secure
		* Uninstall the normal linux kernel to free up space in /boot, ```pacman -Rns linux``` 
	* Video Card Drivers:
		* NVIDIA: add ```nvidia nvidia-utils libva-vdpau-driver xorg-server-devel nvidia-settings opencl-nvidia```
		* AMD: add ```xf86-video-amdgpu mesa libva-mesa-driver mesa-vdpau```
		* INTEL: add ```xf86-video-intel mesa libva-intel-driver libvdpau-va-gl```
9) configure installed packages
	1) enabled gdm, ```systemctl enable gdm```
    2) switch to zsh, ```chsh -s /usr/bin/zsh```
10) set up bootloader (systemd-boot), ```bootctl install```, then configure it
	* Set ```/boot/loader/loader.conf``` to (each bullet point is a new line)
		* ```default arch[-kernelname, none if you didn't install a different one]``` (e.g. default arch-zen)
		* ```timeout 5```
		*  ```editor 0```
	* Create /boot/loader/entries/arch[-kernel name].conf
		* ```title          Arch Linux```
		* ```linux          /vmlinuz-linux[-kernel name]```
		* IF you have an intel cpu add: ```initrd         /intel-ucode.img```
		* ```initrd         /initramfs-linux[-kernel name].img```
		* ```options        root=```
			* IF you used lvm for part 2, set ```options root=``` to the location of your root partition logical volume, e.g. ```/dev/mapper/VolGroup00-rootpart```
			* Otherwise, find your UUID by first knowing your /dev/sdXn of your root partition (use ```fdisk -l``` to find it), and then ```ls /dev/disk/by-partuuid -l``` and finding which uuid -> to your sdXn.  Write that down and edit that the options line to be ```options root=PARTUUID=[your part uuid]``` to it
			* Either way, add a space and ```rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3``` to the end of the options line.  If you would like to enable hibernate, add ```resume=PARTUUID=[your swap partition]```
			* For a marginal boot speed increase, edit ```/etc/fstab``` and remove the ```rw``` line from your ```/``` partition, as systemd will now do that instead

11) Set your hostname in ```/etc/hostname```, set the file to the name, e.g. ```DesktopArch```
12) enable the dhcpcd service to ensure we get an ip on reboot, ```systemctl enable dhcpcd.service```
13) set the root password ```passwd```
14) add a new user: ```useradd -m -g users -G wheel,storage,power -s /bin/zsh 'username'```
	* set a password for this user, passwd 'username'
15) Add the ```wheel``` group to the sudoers file, run ```visudo``` and find the line that says ```Uncomment to allow members of group wheel to execute any command```, uncomment that line
15) ```exit``` to exit the Chroot, ```umount -R /mnt``` to unmount everything, and then ```reboot``` and pull out your usb drive
16) Continue to 4 - After rebooting if reboot was successful, otherwise 3b - Fixing failed boot if it wasn't
