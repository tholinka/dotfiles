1. Enable chromium hardware accel
    * chrome://flags/#ignore-gpu-blacklist -> enable
    * chrome://flags/#enable-gpu-rasterization -> enable (this might break some websites fonts)
    * chrome://flags/#enable-zero-copy -> enable
1. Enable nightlight / flux.  Install ```redshift plasma5-applets-redshift-control``` and then ```right click on the task bar -> unlock widgets``` ```Right click on taskbar again -> Panel options -> Add widgets -> redshift```
1. install printers
    * install ```cups gtk3-print-backends cups-pdf```
    * enable / start the service ```systemctl enable org.cups.cupsd.service``` ```systemctl start org.cups.cupsd.service```
1. set up firewall
    * run ```gufw```, turn ```status``` to on, and that's good enough
1. enable color in pacman: uncomment ```Color``` in ```/etc/pacman.conf```
1. enable syslog forwarding to journalctl: install ```syslog-ng```, and enable it through ```systemctl enable syslog-ng```
    * start it as well, if not restarting
1. enable fingerprint unlocking.  Install ```fprint```
    * enroll fingerprint using ```fprintd-enroll```
    * add the following: ```auth      sufficient pam_fprintd.so``` to the top of the auth lines in the following files
        * ```/etc/pam.d/system-local-login```
1. Misc kde settings:
    * Look and Feel theme I use is "Breeze Dark", Desktop theme I use is "Ember", gtk theme is "Vertex Dark" (which is installed in one of the scripts)
    * Moka as my icon theme, humanity is my cursor theme
