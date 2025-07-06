#!/bin/bash

set -euo pipefail

echo "==============================="
echo " Pi-hole Automation Uninstaller"
echo "==============================="

BIN_DIR="/usr/local/bin"
CRON_FILE="/etc/cron.d/pihole-automation"
LOGROTATE_CONF="/etc/logrotate.d/pihole-automation"

echo "Removing scripts from $BIN_DIR..."
for script in "$BIN_DIR"/update-*.sh; do
  if [ -f "$script" ]; then
    echo "Deleting $script"
    sudo rm -f "$script"
  else
    echo "No script found: $script"
  fi
done

echo "Removing cron job: $CRON_FILE"
if [ -f "$CRON_FILE" ]; then
  sudo rm -f "$CRON_FILE"
else
  echo "No cron file found."
fi

echo "Removing logrotate config: $LOGROTATE_CONF"
if [ -f "$LOGROTATE_CONF" ]; then
  sudo rm -f "$LOGROTATE_CONF"
else
  echo "No logrotate config found."
fi

echo ""
echo "Leaving logs in /var/log/ for audit reference."
echo "You can remove them manually if you wish:"
echo "   sudo rm /var/log/update-*.log"

echo ""
echo "==============================="
echo " Uninstall complete"
echo "==============================="
