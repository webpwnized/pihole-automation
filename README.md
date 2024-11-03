
# Pi-hole Automation

**Pi-hole Automation** is a collection of scripts designed to automate maintenance tasks for a Pi-hole DNS server and its underlying Raspberry Pi operating system. These scripts are scheduled with `cron` to ensure that the Pi-hole instance and the system are always up-to-date and performing optimally.

## Project Structure

- **cron-jobs/cron.custom/**: Contains custom cron job scripts for different maintenance tasks, including Debian updates, Pi-hole gravity updates, Pi-hole software updates, and Raspberry Pi firmware updates.
- **crontab**: A sample crontab configuration file, defining specific times for each maintenance task.
- **lists.txt**: A list of URLs to popular blocklists that can be imported into Pi-hole, providing a baseline for ad-blocking and privacy protection.

## Scripts

The following scripts are included in the `cron-jobs/cron.custom/` directory and are intended to be scheduled with cron for automated execution.

### Daily Updates

These scripts perform daily maintenance to ensure Pi-hole and the underlying system are up-to-date.

- **`update-debian.sh`**: Updates the Debian operating system on the Raspberry Pi using `apt`. This includes fetching and applying package updates for system stability and security.
- **`update-gravity.sh`**: Updates Pi-hole’s gravity list, which refreshes the blocklists used to block ads and trackers, keeping them current.
- **`update-pihole.sh`**: Updates the Pi-hole software itself, ensuring the latest features and security patches are applied.

### Monthly Updates

This script performs a less frequent, but essential, update to the Raspberry Pi’s firmware.

- **`update-pi-firmware.sh`**: Updates the Raspberry Pi firmware using `rpi-update`, which may include performance enhancements and hardware compatibility improvements. This script is scheduled to run monthly to keep the firmware up-to-date without risking frequent interruptions.

## Usage

### Setting Up the Cron Jobs

1. **Move Scripts to Custom Directory**:
   Place the scripts in `/etc/cron.custom/` to prevent them from being run by default cron directories (e.g., `/etc/cron.daily`). This allows for precise scheduling.

   ```bash
   sudo mkdir -p /etc/cron.custom
   sudo cp cron-jobs/cron.custom/* /etc/cron.custom/
   sudo chmod +x /etc/cron.custom/*.sh
   ```

2. **Configure the Crontab**:
   Use the provided `crontab` file as a template to schedule each script at the specified times. Open the root crontab and add entries for each script.

   ```bash
   sudo crontab -e
   ```

   Then, add the contents of the provided `crontab` file to set the desired schedule.

### Example Crontab Schedule

The `crontab` file schedules each script with specific times for daily and monthly tasks:
- **Debian updates**: 2:00 AM daily
- **Pi-hole gravity updates**: 3:00 AM daily
- **Pi-hole software updates**: 4:00 AM daily
- **Raspberry Pi firmware updates**: 5:00 AM on the 1st of each month

This configuration ensures the Pi-hole instance and Raspberry Pi are maintained without interfering with each other or other system tasks.

### Importing Blocklists

The `lists.txt` file includes popular URLs for blocklists that can be imported into Pi-hole. To use these blocklists:
1. Open the Pi-hole web interface.
2. Go to **Group Management > Adlists**.
3. Copy the URLs from `lists.txt` and paste them into the Adlists section.

## Logs

Each script logs its output to a unique file in `/var/log/`, making it easy to review and troubleshoot:
- **Debian update log**: `/var/log/update-debian-cron.log`
- **Gravity update log**: `/var/log/update-gravity-cron.log`
- **Pi-hole update log**: `/var/log/update-pihole-cron.log`
- **Firmware update log**: `/var/log/update-pi-firmware-cron.log`

Check these logs periodically to verify that each task completes successfully.

## License

This project is licensed under the GNU GPL v3. See the [LICENSE](LICENSE) file for details.
