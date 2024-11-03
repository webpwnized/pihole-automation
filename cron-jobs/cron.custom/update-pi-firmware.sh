#!/bin/bash

# Define log file path
LOG_FILE="/var/log/update-pi-firmware.log"

# Redirect stdout and stderr to the log file, with real-time feedback
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to log errors and exit if firmware update fails
log_error() {
    echo "[$(date)] ERROR: Raspberry Pi firmware update failed on line $1. Check the log for details."
    exit 1
}

# Trap any errors and call log_error function
trap 'log_error $LINENO' ERR

# Log header
echo "=============================="
echo "Raspberry Pi Firmware Update"
echo "Start Date: $(date)"
echo "=============================="

# Perform the firmware update with the -y flag to auto-confirm
echo "Running rpi-update to update firmware..."
if sudo rpi-update -y; then
    echo "[$(date)] SUCCESS: Raspberry Pi firmware updated successfully."
else
    echo "[$(date)] ERROR: Firmware update encountered an issue."
    exit 1
fi

# Wait for a few seconds before rebooting
sleep 3s

# Log reboot message
echo "[$(date)] Rebooting system to apply firmware update..." 

# Reboot the system
sudo reboot
