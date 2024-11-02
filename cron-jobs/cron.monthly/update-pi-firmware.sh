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

# Perform the firmware update
echo "Running rpi-update to update firmware..."
if sudo rpi-update; then
    echo "[$(date)] SUCCESS: Raspberry Pi firmware updated successfully."
else
    echo "[$(date)] ERROR: Firmware update encountered an issue."
    exit 1
fi

# Wait for a few seconds before rebooting
sleep 3s

# Confirmation prompt for reboot (uncomment if you want to confirm manually)
# read -p "Firmware updated. Reboot now? (y/n): " confirm && [[ $confirm == [yY] ]] || exit 1

# Log reboot message
echo "[$(date)] Rebooting system to apply firmware update..." 

# Reboot the system
sudo reboot
