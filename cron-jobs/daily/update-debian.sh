#!/bin/bash

sudo apt-get update > /var/log/update-debian.log 2>&1
sudo apt-get dist-upgrade -y >> /var/log/update-debian.log 2>&1
sudo apt-get autoremove -y >> /var/log/update-debian.log 2>&1
sudo apt-get autoclean >> /var/log/update-debian.log 2>&1
echo "" >> /var/log/update-debian.log
echo $(date) >> /var/log/update-debian.log