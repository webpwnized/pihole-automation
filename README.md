# Pi-hole Automation

**Pi-hole Automation** is a collection of scripts to automate maintenance tasks for a Pi-hole DNS server and its underlying Raspberry Pi OS (Debian) system. These scripts run via `cron` to keep your Pi-hole and operating system secure, updated, and stable.

## Project Structure

- `cron-jobs/cron.custom/` — Contains the update scripts for Debian, Pi-hole gravity, Pi-hole core, and Raspberry Pi firmware.
- `lists.txt` — Popular blocklist URLs you can import into Pi-hole.
- `install.sh` — Sets up the automation: installs scripts, cron job, and logrotate.
- `status.sh` — Shows system version, Pi-hole version, and recent log output.
- `uninstall.sh` — Removes the installed scripts, cron job, and logrotate config.

## Scripts

These scripts live in `cron-jobs/cron.custom/` and get installed to `/usr/local/bin/`.

### Daily Updates

- `update-debian.sh` — Runs `apt update` and `apt full-upgrade` to keep Debian packages secure.
- `update-gravity.sh` — Refreshes Pi-hole’s gravity list to update ad/tracker blocklists.
- `update-pihole.sh` — Updates Pi-hole core software for security patches and improvements.

### Monthly Updates

- `update-pi-firmware.sh` — Updates the Raspberry Pi kernel and bootloader EEPROM using safe `apt` and `rpi-eeprom-update` (only when supported). Runs monthly to keep the firmware up-to-date without unnecessary risk.

## Usage

### Install

Clone and run the installer:

    git clone https://github.com/webpwnized/pihole-automation.git
    cd pihole-automation
    chmod +x install.sh
    ./install.sh

The installer:
- Copies all update scripts to `/usr/local/bin/`
- Installs `/etc/cron.d/pihole-automation` for precise scheduling
- Creates log files in `/var/log/`
- Installs a logrotate config to manage log size
- Verifies that `cron` is enabled and running

### Cron Schedule

The installer writes a cron schedule to `/etc/cron.d/pihole-automation`:

| Task | Schedule |
|------------------------|------------------------|
| Debian updates | Daily at 04:00 AM |
| Gravity updates | Daily at 05:00 AM |
| Pi-hole software update | Daily at 06:00 AM |
| Firmware update | Monthly at 07:00 AM on the 1st |

### Import Blocklists

The `lists.txt` file contains popular blocklist URLs.  
To use them:
1. Open the Pi-hole web admin interface.
2. Go to **Group Management > Adlists**.
3. Copy the URLs from `lists.txt` and paste them in.

### Check Status

Run the `status.sh` script to see:
- Kernel version
- EEPROM bootloader version (if applicable)
- Pi-hole version
- Recent lines from each update log

    ./status.sh

### Logs

Each script writes to its own log in `/var/log/`:

- `/var/log/update-debian.log`
- `/var/log/update-gravity.log`
- `/var/log/update-pihole.log`
- `/var/log/update-pi-firmware.log`

Logs are rotated weekly by `logrotate`.

## Uninstall

Run `uninstall.sh` to remove:
- `/usr/local/bin/update-*.sh` scripts
- `/etc/cron.d/pihole-automation`
- `/etc/logrotate.d/pihole-automation`

Example:

    ./uninstall.sh

The logs in `/var/log/` remain for your records — remove them manually if needed.

## License

This project is licensed under the GNU GPL v3. See the [LICENSE](LICENSE) file for details.
