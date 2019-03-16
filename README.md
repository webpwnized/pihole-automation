# pihole-automation
Scripts to automate maintenance of Pi-Hole DNS server. These scripts are run by cron. The exact time can be set up using the crontab program. A working example is provided in file *crontab*

## Daily updates
- update-debian.sh: Updates the Debian operating system using apt
- Pi-Hole subsystems: Updates components of Pi-Hole
- Pi-Hole gravity: Updates the blocklists used by Pi-Hole

## Weekly updates
- update-pi-firmware.sh: Updates Raspberry Pi firmware using rpi-update
