#!/bin/bash

LOG_FILE="/var/log/update-pi-firmware.log"
exec > >(tee -a "$LOG_FILE") 2>&1

log() {
  echo "[$(date)] $*"
}

log_error() {
  log "ERROR: Firmware update failed on line $1."
  exit 1
}

trap 'log_error $LINENO' ERR

log "=============================="
log "Raspberry Pi Firmware & Kernel Update"
log "=============================="

log "Updating Raspberry Pi firmware using apt..."
sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

if ! command -v rpi-eeprom-update >/dev/null 2>&1; then
  log "WARNING: rpi-eeprom-update not found. Skipping EEPROM update."
else
  log "Updating bootloader EEPROM..."
  sudo rpi-eeprom-update -a
fi

log "SUCCESS: Firmware packages updated. A reboot may be required."

log "=============================="
log "Update Finished"
log "End Date: $(date)"
log "=============================="
