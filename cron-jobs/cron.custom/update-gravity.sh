#!/bin/bash

# Define log file
LOG_FILE="/var/log/update-gravity.log"

# Redirect stdout and stderr to the log file, with real-time feedback
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to log errors and exit if Pi-hole update fails
log_error() {
    echo "[$(date)] ERROR: Pi-hole gravity update failed on line $1. Check the log for details."
    exit 1
}

# Trap any errors and call log_error
trap 'log_error $LINENO' ERR

# Header in log file
echo "============================="
echo "Pi-hole Gravity Update Start"
echo "Date: $(date)"
echo "============================="

# Update Pi-hole gravity
echo "Updating Pi-hole blocklist (gravity)..."
if sudo pihole -g; then
    echo "[$(date)] SUCCESS: Pi-hole gravity update completed successfully."
else
    echo "[$(date)] ERROR: Pi-hole gravity update failed."
    exit 1
fi

# Optional: Notify user via email on completion
# Uncomment the following lines and replace 'you@example.com' with your email if you want to receive notifications
# EMAIL="you@example.com"
# echo "Pi-hole Gravity Update completed at $(date)" | mail -s "Pi-hole Update Status" $EMAIL

# Completion message in the log file
echo "============================="
echo "Update Finished"
echo "End Date: $(date)"
echo "============================="
