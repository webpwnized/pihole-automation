#!/bin/bash

sudo pihole -up > /var/log/update-pihole.log 2>&1
echo "" >> /var/log/update-pihole.log
echo $(date) >> /var/log/update-pihole.log