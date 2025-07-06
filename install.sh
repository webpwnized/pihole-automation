#!/bin/bash

set -euo pipefail

# ===========
# Pi-hole Automation Installer (Hardened, Linux Standard)
# ===========

# CONFIG
SCRIPT_SOURCE_DIR="./cron-jobs/cron.custom"
INSTALL_BIN_DIR="/usr/local/bin"
CRON_FILE="/etc/cron.d/pihole-automation"
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

info "Found update scripts:"
ls -1 "$SCRIPT_SOURCE_DIR"/update-*.sh

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
# 3. Install scripts to /usr/local/bin
# ===========

info "Copying update scripts to $INSTALL_BIN_DIR"

for script in "$SCRIPT_SOURCE_DIR"/update-*.sh; do
  script_name=$(basename "$script")
  info "Copying $script_name"
  sudo cp "$script" "$INSTALL_BIN_DIR/$script_name" || error_exit "Could not copy $script"
  sudo chmod 750 "$INSTALL_BIN_DIR/$script_name" || error_exit "Could not set permissions for $script_name"
done

# Verify they exist now
for script in "$SCRIPT_SOURCE_DIR"/update-*.sh; do
  script_name=$(basename "$script")
  if [ ! -f "$INSTALL_BIN_DIR/$script_name" ]; then
    error_exit "Expected $INSTALL_BIN_DIR/$script_name but it does not exist."
  fi
done

info "All update scripts installed to $INSTALL_BIN_DIR"

# ===========
# 4. Create log files
# ===========

info "Creating log files in /var/log"

for log in /var/log/update-pihole.log \
           /var/log/update-gravity.log \
           /var/log/update-debian.log \
           /var/log/update-pi-firmware.log; do
  sudo touch "$log" || error_exit "Could not create $log"
  sudo chown root:adm "$log" || error_exit "Could not set owner for $log"
  sudo chmod 640 "$log" || error_exit "Could not set permissions for $log"
done

# ===========
# 5. Install /etc/cron.d file
# ===========

info "Writing cron schedule to $CRON_FILE"

sudo tee "$CRON_FILE" >/dev/null <<EOF
# Pi-hole Automation Cron Jobs
# Format: minute hour day month weekday user command

0 4 * * * root $INSTALL_BIN_DIR/update-debian.sh >> /var/log/update-debian.log 2>&1
0 5 * * * root $INSTALL_BIN_DIR/update-gravity.sh >> /var/log/update-gravity.log 2>&1
0 6 * * * root $INSTALL_BIN_DIR/update-pihole.sh >> /var/log/update-pihole.log 2>&1
0 7 1 * * root $INSTALL_BIN_DIR/update-pi-firmware.sh >> /var/log/update-pi-firmware.log 2>&1
EOF

sudo chmod 644 "$CRON_FILE" || error_exit "Could not set permissions for $CRON_FILE"

# Verify cron file exists
if [ ! -f "$CRON_FILE" ]; then
  error_exit "Expected cron file $CRON_FILE does not exist after creation."
fi

info "Cron file created: $CRON_FILE"

# ===========
# 6. Setup logrotate
# ===========

info "Installing logrotate config at $LOGROTATE_CONF"

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
# 7. Ensure cron is installed and running
# ===========

if ! command -v cron >/dev/null 2>&1 && ! systemctl list-units --type=service | grep -q cron; then
  error_exit "Cron is not installed on this system. Please install cron first."
fi

info "Enabling and restarting cron service"

sudo systemctl enable cron || error_exit "Could not enable cron service"
sudo systemctl restart cron || error_exit "Could not restart cron service"

info "Pi-hole Automation installation completed successfully"
