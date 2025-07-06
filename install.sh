#!/bin/bash

set -euo pipefail

# ===========
# Pi-hole Automation Installer (Hardened, Plain)
# ===========
# Assumes you run it INSIDE a valid cloned repo
# ===========

# CONFIG
SCRIPT_SOURCE_DIR="./cron-jobs/cron.custom"
CRON_DIR="/etc/cron.custom"
LOGROTATE_CONF="/etc/logrotate.d/pihole-automation"

info() {
  echo "INFO: $*"
}

error_exit() {
  echo "ERROR: $*" >&2
  exit 1
}

# ===========
# 1. Pre-checks
# ===========

info "Starting Pi-hole Automation Installer"

if [ "$EUID" -eq 0 ]; then
  error_exit "Do not run this script directly as root. Use a normal user with sudo."
fi

if ! command -v sudo >/dev/null 2>&1; then
  error_exit "sudo is required but not installed."
fi

if [ ! -d "$SCRIPT_SOURCE_DIR" ]; then
  error_exit "Source directory '$SCRIPT_SOURCE_DIR' does not exist. Are you in the correct repo?"
fi

sh_files=$(ls "$SCRIPT_SOURCE_DIR"/update-*.sh 2>/dev/null || true)
if [ -z "$sh_files" ]; then
  error_exit "No update-*.sh files found in '$SCRIPT_SOURCE_DIR'."
fi

# ===========
# 2. Pi-hole check
# ===========

if ! command -v pihole >/dev/null 2>&1; then
  info "Pi-hole not found. Installing..."
  curl -sSL https://install.pi-hole.net | bash || error_exit "Pi-hole install failed."
else
  info "Pi-hole is installed."
fi

# ===========
# 3. Install cron jobs
# ===========

info "Creating cron directory at '$CRON_DIR'"
sudo mkdir -p "$CRON_DIR" || error_exit "Could not create cron directory"

info "Copying update scripts"
sudo cp "$SCRIPT_SOURCE_DIR"/update-*.sh "$CRON_DIR" || error_exit "Could not copy scripts"

info "Making scripts executable"
sudo chmod +x "$CRON_DIR"/update-*.sh || error_exit "Could not make scripts executable"

# ===========
# 4. Setup logs
# ===========

info "Creating log files"
for log in /var/log/update-pihole.log \
           /var/log/update-gravity.log \
           /var/log/update-debian.log \
           /var/log/update-pi-firmware.log; do
  sudo touch "$log" || error_exit "Could not create $log"
  sudo chown root:adm "$log" || error_exit "Could not set owner on $log"
  sudo chmod 640 "$log" || error_exit "Could not set permissions on $log"
done

# ===========
# 5. Setup logrotate
# ===========

info "Writing logrotate config to '$LOGROTATE_CONF'"
sudo tee "$LOGROTATE_CONF" >/dev/null <<EOF
/var/log/update-*.log {
    weekly
    rotate 4
    compress
    missingok
    notifempty
    create 640 root adm
}
EOF

# ===========
# 6. Ensure cron is installed and running
# ===========

if ! command -v cron >/dev/null 2>&1 && ! systemctl list-units --type=service | grep -q cron; then
  error_exit "Cron is not installed on this system. Please install cron first."
fi

info "Enabling and restarting cron service"
sudo systemctl enable cron || error_exit "Could not enable cron service"
sudo systemctl restart cron || error_exit "Could not restart cron service"

info "Pi-hole Automation install completed successfully"
