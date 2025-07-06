#!/bin/bash

set -euo pipefail

echo "==============================="
echo " Pi-hole Automation Status"
echo "==============================="

echo ""
echo "System:"
echo "--------------------------------"
echo "Hostname: $(hostname)"
echo "Kernel : $(uname -a)"
echo ""

# EEPROM version (Pi only)
if command -v rpi-eeprom-update >/dev/null 2>&1; then
  echo "Bootloader EEPROM:"
  echo "--------------------------------"
  sudo rpi-eeprom-update
else
  echo "Bootloader EEPROM: N/A (rpi-eeprom-update not found)"
fi

echo ""
echo "Pi-hole Version:"
echo "--------------------------------"
if command -v pihole >/dev/null 2>&1; then
  pihole -v
else
  echo "Pi-hole not found!"
fi

echo ""
echo "Update Logs:"
echo "--------------------------------"

for log in /var/log/update-debian.log \
           /var/log/update-gravity.log \
           /var/log/update-pihole.log \
           /var/log/update-pi-firmware.log; do
  echo ""
  echo "==> $log"
  if [ -f "$log" ]; then
    echo "Last updated: $(ls -lh --time-style=long-iso "$log" | awk '{print $6, $7}')"
    tail -n 10 "$log"
  else
    echo "Log file not found: $log"
  fi
done

echo ""
echo "==============================="
echo " Status check complete"
echo "==============================="
