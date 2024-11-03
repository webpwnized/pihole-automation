#!/bin/bash

# Define log file
LOG_FILE="/var/log/update-pihole.log"

# Redirect stdout and stderr to the log file, with real-time feedback
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to log errors and exit if Pi-hole update fails
log_error() {
    echo "[$(date)] ERROR: Pi-hole update failed on line $1. Check the log for details."
    exit 1
}

# Trap any errors and call log_error
trap 'log_error $LINENO' ERR

# Log header
echo "============================="
echo "Pi-hole Update Script Started"
echo "Date: $(date)"
echo "============================="

# Perform Pi-hole update
echo "Updating Pi-hole software..."
if sudo pihole -up; then
    echo "[$(date)] SUCCESS: Pi-hole software updated successfully."
else
    echo "[$(date)] ERROR: Pi-hole update encountered an issue."
    exit 1
fi

# Optional: Notify user via email on completion
# Uncomment the following lines and replace 'you@example.com' with your email to receive notifications
# EMAIL="you@example.com"
# echo "Pi-hole Update completed at $(date)" | mail -s "Pi-hole Update Status" $EMAIL

# Completion log entry
echo "============================="
echo "Update Finished Successfully"
echo "End Dat
