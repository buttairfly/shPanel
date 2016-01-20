#!/bin/bash

wget http://goo.gl/1BOfJ -O /usr/bin/rpi-update
chmod +x /usr/bin/rpi-update
rpi-update

read -p "Reboot now? [Y/n]: " reboot
if [[ reboot != n ]]; then
	shutdown -h now
	exit 0
fi
exit -1
