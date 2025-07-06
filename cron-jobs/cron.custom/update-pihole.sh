#!/bin/bash

LOG_FILE="/var/log/update-pihole.log"
exec > >(tee -a "$LOG_FILE") 2>&1

log() {
  echo "[$(date)] $*"
}

log_error() {
  log "ERROR: Pi-hole update failed on line $1."
  exit 1
}

trap 'log_error $LINENO' ERR

log "============================="
log "Pi-hole Update Script Started"
log "============================="

log "Updating Pi-hole software..."
sudo pihole -up

log "SUCCESS: Pi-hole software updated successfully."

log "============================="
log "Update Finished Successfully"
log "End Date: $(date)"
log "============================="
