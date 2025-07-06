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
log "Raspberry Pi Firmware Update"
log "=============================="

log "Updating Raspberry Pi firmware using apt..."
sudo apt update
sudo apt full-upgrade -y
sudo rpi-eeprom-update -a

log "SUCCESS: Firmware packages updated. A reboot may be required."

log "=============================="
log "Update Finished"
log "End Date: $(date)"
log "=============================="
