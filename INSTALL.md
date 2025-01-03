
# Installation Guide for Pi-hole Automation

This guide will help you set up automation scripts for maintaining a Pi-hole DNS server on a Raspberry Pi. These scripts handle daily and monthly tasks, such as updating Debian packages, refreshing Pi-hole's blocklists, updating Pi-hole software, and upgrading Raspberry Pi firmware.

## Prerequisites

Before setting up this project, ensure you have the following:

1. **Pi-hole Installed**: You should have Pi-hole already installed on your Raspberry Pi. For installation instructions, refer to the [official Pi-hole website](https://pi-hole.net/).
2. **Basic Knowledge of Linux and Cron**: Familiarity with the command line and basic Linux commands is helpful.
3. **Permissions**: You need `sudo` (administrator) access on your Raspberry Pi.

## Step 1: Clone the Repository

1. Open a terminal on your Raspberry Pi.
2. Clone the repository from GitHub to download all scripts and files:
   ```bash
   git clone https://github.com/webpwnized/pihole-automation.git
   cd pihole-automation
   ```

This will create a `pihole-automation` directory containing the automation scripts.

## Step 2: Move Scripts to the Custom Cron Directory

To ensure the scripts run at specified times, copy them to a dedicated cron directory. This keeps them separate from the default daily, weekly, and monthly cron directories.

1. **Create a custom cron directory** (if it doesn't already exist):
   ```bash
   sudo mkdir -p /etc/cron.custom
   ```

2. **Copy the scripts** to `/etc/cron.custom/`:
   ```bash
   sudo cp cron-jobs/cron.custom/* /etc/cron.custom/
   ```

3. **Make the scripts executable**:
   ```bash
   sudo chmod +x /etc/cron.custom/*.sh
   ```

This places all scripts in a separate directory, allowing you to set specific times without interference from default cron intervals.

## Step 3: Set Up the Cron Schedule

The `crontab` file provided in the project contains a sample schedule for automating these tasks at specific times. Use this file as a template to set up your crontab.

1. **Edit the root crontab** to apply the custom schedule:
   ```bash
   sudo crontab -e
   ```

2. **Add the schedule** by copying and pasting the following lines into the crontab editor:

   ```plaintext
   # Custom scheduled tasks for Pi-hole and Raspberry Pi maintenance

   # Update Debian packages daily at 2:00 AM
   0 2 * * * /etc/cron.custom/update-debian.sh >> /var/log/update-debian-cron.log 2>&1

   # Update Pi-hole gravity (blocklists) daily at 3:00 AM
   0 3 * * * /etc/cron.custom/update-gravity.sh >> /var/log/update-gravity-cron.log 2>&1

   # Update Pi-hole software daily at 4:00 AM
   0 4 * * * /etc/cron.custom/update-pihole.sh >> /var/log/update-pihole-cron.log 2>&1

   # Update Raspberry Pi firmware monthly on the 1st day at 5:00 AM
   0 5 1 * * /etc/cron.custom/update-pi-firmware.sh >> /var/log/update-pi-firmware-cron.log 2>&1
   ```

3. **Save and exit** the crontab editor. This will schedule each task as follows:
   - **2:00 AM daily**: Updates Debian packages.
   - **3:00 AM daily**: Refreshes Pi-hole’s gravity (blocklist).
   - **4:00 AM daily**: Updates Pi-hole software.
   - **5:00 AM on the 1st of each month**: Upgrades Raspberry Pi firmware.

## Step 4: Import Custom Blocklists (Optional)

The file `lists.txt` contains popular blocklist URLs that can be added to Pi-hole for enhanced ad-blocking and privacy.

1. **Open the Pi-hole web interface**: Navigate to `http://<your-pi-ip-address>/admin` in your browser.
2. **Go to Group Management > Adlists**.
3. **Copy the URLs** from `lists.txt` and paste them into the Adlists section.
4. **Save and update gravity** to apply the blocklists.

## Step 5: Verify Cron Job Execution

After setting up the cron jobs, each task will log its output to `/var/log/`, allowing you to verify that the scripts are running as expected.

- **Check logs** with the following commands:
   ```bash
   tail /var/log/update-debian-cron.log
   tail /var/log/update-gravity-cron.log
   tail /var/log/update-pihole-cron.log
   tail /var/log/update-pi-firmware-cron.log
   ```

   Review these logs periodically to ensure the tasks complete without errors.

## Troubleshooting

- **Scripts Not Running**: Ensure each script in `/etc/cron.custom/` has execute permissions (`chmod +x`).
- **Cron Job Errors**: Check the specific log file for each job in `/var/log/` to see if any errors are reported.
- **Connection Issues**: Ensure your Raspberry Pi has a stable internet connection for Debian and Pi-hole updates.

## Uninstallation

To remove the automation scripts and their scheduled tasks:

1. **Remove the scripts** from `/etc/cron.custom/`:
   ```bash
   sudo rm -f /etc/cron.custom/update-*.sh
   ```

2. **Edit the root crontab** and delete any lines that reference `/etc/cron.custom` scripts.

3. Optionally, delete log files associated with the tasks in `/var/log/`.

## Additional Resources

- [Pi-hole Documentation](https://docs.pi-hole.net/)
- [GNU General Public License (GPLv3)](https://www.gnu.org/licenses/gpl-3.0.txt)

---

Following these steps will set up automated maintenance for your Pi-hole and Raspberry Pi system, keeping everything current and optimized.
