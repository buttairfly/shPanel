install and scripts for Panel

first run on a clean rasbian:


`raspi-config`
*  set your password
*  enable SPI


`cd ~`

`git clone https://github.com/buttairfly/shPanel shPanel`

`sudo ./shPanel/update.sh`

`sudo ./shPanel/spi.sh`
*  reboot

`sudo ./shPanel/clean.sh`

`sudo ./shPanel/install.sh`
