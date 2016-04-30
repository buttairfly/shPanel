#!/bin/bash

./update.sh

echo
echo Change password:
passwd

echo
read -p "Update hostname? [Y/n]: " reboot
if [[ reboot != n ]]; then
        read -p "Enter new hostname: " hostname
        cat $hostname > /etc/hostname
fi

wget http://goo.gl/1BOfJ -O /usr/bin/rpi-update
chmod +x /usr/bin/rpi-update
rpi-update

raspi-config

read -p "Reboot now? [Y/n]: " reboot
if [[ reboot != n ]]; then
        shutdown -h now
        exit 0
fi
exit -1
