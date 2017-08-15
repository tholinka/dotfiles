# Installing Part 3b - Fixing failed boot
###### This assumes that Part 3 is already done and you restarted.  And that failed
1) note down your /dev/disk/by-partuuid's in the emergency terminal (if you have one) and reboot to the usb.  Remount your partitions in the usb (at the very least /mnt and /mnt/boot).  Double check your PARTUUID's are correct.  run ```mkinitcpio -p linux[-kernel name]```
2) If your PARTUUID's aren't wrong, and mkinitcpio didn't find it, move the lines after "rw" on the ```OPTIONS=``` line of ```/boot/entries/loader/arch[-kernelname].conf``` to a new line and add a ```#``` at the beginning to comment them out and reboot and see if the error messages are useful.  Additionally, check to make sure ```/boot/entries/loader/loader.conf``` is set to default to the correct config.  Also run ```bootctl update```
3) If the issue is corrupted graphics, add ```nomodeset``` or ```vga=current``` to the end of the ```options=``` line
