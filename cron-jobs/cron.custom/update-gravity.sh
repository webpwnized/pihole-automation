#!/bin/bash

LOG_FILE="/var/log/update-gravity.log"
exec > >(tee -a "$LOG_FILE") 2>&1

log() {
  echo "[$(date)] $*"
}

log_error() {
  log "ERROR: Pi-hole gravity update failed on line $1."
  exit 1
}

trap 'log_error $LINENO' ERR

log "============================="
log "Pi-hole Gravity Update Start"
log "============================="

log "Updating Pi-hole blocklist (gravity)..."
sudo pihole -g

log "SUCCESS: Pi-hole gravity update completed successfully."

log "============================="
log "Update Finished"
log "End Date: $(date)"
log "============================="
