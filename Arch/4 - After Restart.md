# Installing Part 4 - After restart

> This assumes that Part 3 is already done and you restarted.    And that succeeded.

1. Login as root
1. add a new user: ```useradd -m -g users -G wheel,storage,power -s /bin/bash 'username'```
    * set a password for this user, passwd 'username'
1. Add the ```wheel``` group to the sudoers file, run ```EDITOR=vim visudo``` and find the line that says ```Uncomment to allow members of group wheel to execute any command```, uncomment that line
1. ```exit``` and login to your user account
1. ```ping google.com```, if you don't have a connection, repeat process from step 1
1. Clone this repository into something like .settings-git, ```git clone --recursive git@github.com:link07/Linux-Settings-and-Setup.git .settings-git
1. Run FirstSetup.sh in Arch/Scripts
1. configure installed packages
    1. switch to new kernel (if installed)
        * edit ```/boot/loader/loader.conf``` to default to linux-[kernel name], e.g. linux-zen
        * copy ```/boot/loader/config/arch.conf``` to arch-[kernel name].conf
        * add ```-kernelname``` to the vmlinuz and initramfs lines of the config
1. Reconfigure boot options to enable hibernate, and be quieter and faster
    * Add the following to the end of the ```options``` line in ```/boot/loader/[your config]```
        * ```rw splash quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log-priority=3``` to have startup / stop be show less information
        * ```resume=PARTUUID=[your swap partition's partuuid]``` to enable hibernation
    * For a marginal boot speed increase, edit ```/etc/fstab``` and remove the ```rw``` line from your ```/``` partition, as systemd will now do that instead
1. reboot again, you should reboot into a login menu. (it may be ugly until you manually change the them, then change it back to the default in the KDE settings)
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
1. run AurSetup.sh to install trizen (pacaur's replacement)
1. Continue to Part 5, misc setup
