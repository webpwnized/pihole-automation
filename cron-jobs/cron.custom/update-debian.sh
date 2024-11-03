#!/bin/bash

# Define log file path
LOG_FILE="/var/log/update-debian.log"

# Redirect stdout and stderr to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Log header with timestamp
echo "====================="
echo "Update started: $(date)"
echo "====================="

# Function to log errors and exit if a command fails
log_error() {
    echo "Error on line $1"
    exit 1
}

# Trap errors and call log_error function
trap 'log_error $LINENO' ERR

# Update package list
echo "Running apt-get update..."
sudo apt-get update

# Perform distribution upgrade
echo "Running apt-get dist-upgrade..."
sudo apt-get dist-upgrade -y

# Remove unused packages
echo "Running apt-get autoremove..."
sudo apt-get autoremove -y

# Clean up apt cache
echo "Running apt-get autoclean..."
sudo apt-get autoclean

# Log completion with timestamp
echo "====================="
echo "Update completed: $(date)"
echo "====================="
