#!/bin/bash

sudo pihole -g > /var/log/update-gravity.log 2>&1
echo "" >> /var/log/update-gravity.log
echo $(date) >> /var/log/update-gravity.log