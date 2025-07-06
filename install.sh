#!/bin/bash

set -euo pipefail

# ===========
# Pi-hole Automation Installer
# Secure install script for Raspberry Pi
# ===========

# CONFIG
REPO_URL="https://github.com/webpwnized/pihole-automation.git"
INSTALL_DIR="$HOME/pihole-automation"
SCRIPT_SOURCE_DIR="$INSTALL_DIR/cron-jobs/cron.custom"
CRON_DIR="/etc/cron.custom"
LOGROTATE_CONF="/etc/logrotate.d/pihole-automation"

# 1. Clone or update repo
echo "[INFO] Cloning or updating repository..."
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "[INFO] Repo exists. Pulling latest..."
  git -C "$INSTALL_DIR" pull
else
  echo "[INFO] Cloning fresh..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

# 2. Ensure Pi-hole is installed
echo "[INFO] Checking for Pi-hole installation..."
if ! command -v pihole >/dev/null 2>&1; then
  echo "[INFO] Pi-hole not found. Installing..."
  curl -sSL https://install.pi-hole.net | bash
else
  echo "[INFO] Pi-hole found."
fi

# 3. Create cron.custom directory
echo "[INFO] Creating custom cron directory..."
sudo mkdir -p "$CRON_DIR"

echo "[INFO] Copying update scripts..."
sudo cp "$SCRIPT_SOURCE_DIR"/update-*.sh "$CRON_DIR"

echo "[INFO] Making scripts executable..."
sudo chmod +x "$CRON_DIR"/update-*.sh

# 4. Create logs and set permissions
echo "[INFO] Ensuring log files exist..."
sudo touch /var/log/update-pihole.log
sudo touch /var/log/update-gravity.log
sudo touch /var/log/update-debian.log
sudo touch /var/log/update-pi-firmware.log

echo "[INFO] Setting permissions for log files..."
sudo chown root:adm /var/log/update-*.log
sudo chmod 640 /var/log/update-*.log

# 5. Setup logrotate
echo "[INFO] Configuring logrotate..."
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

# 6. Ensure cron service is running
echo "[INFO] Checking cron service..."
sudo systemctl enable cron
sudo systemctl restart cron

echo "[INFO] Installation complete. Pi-hole Automation is installed and cron jobs are ready."
