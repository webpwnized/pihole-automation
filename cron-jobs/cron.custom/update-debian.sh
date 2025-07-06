#!/bin/bash

LOG_FILE="/var/log/update-debian.log"
exec > >(tee -a "$LOG_FILE") 2>&1

log() {
  echo "[$(date)] $*"
}

log_error() {
  log "ERROR: Debian update failed on line $1."
  exit 1
}

trap 'log_error $LINENO' ERR

log "============================="
log "Debian Update Script Started"
log "============================="

log "Running apt-get update..."
sudo apt-get update

log "Running apt-get dist-upgrade..."
sudo apt-get dist-upgrade -y

log "Running apt-get autoremove..."
sudo apt-get autoremove -y

log "Running apt-get autoclean..."
sudo apt-get autoclean

log "SUCCESS: Debian system update completed."

log "============================="
log "Update Finished"
log "End Date: $(date)"
log "============================="
