#!/bin/bash

rpi-update > /var/log/update-pi-firmware.log 2>&1
echo ""  >> /var/log/update-pi-firmware.log
echo $(date) >> /var/log/update-pi-firmware.log
sleep 3s
echo "Rebooting system..." >> /var/log/update-pi-firmware.log
reboot