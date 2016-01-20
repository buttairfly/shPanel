#!/bin/bash

wwwLedPanel="https://github.com/MartinTu/Panel"
wwwWireingPi="git://git.drogon.net/wiringPi"


ACTUAL_DIR=$(pwd)
SCRIPT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
INSTAL_DIR=$SCRIPT_DIR/..

WIRING_DIR=$INSTAL_DIR/wiringPi
LEDPANEL_DIR=$INSTAL_DIR/ledPanel
LEDPANELMAKE_DIR=$LEDPANEL_DIR/ledPanel
LEDPANEL_INSTALL_DIR=/usr/bin/led/
echo actual  dir: $ACTUAL_DIR
echo install dir: $INSTAL_DIR
echo script  dir: $SCRIPT_DIR



echo
echo install vim:
command -v vim >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "vim already installed!"
else
	echo "vim needs to be installed:"
	apt-get install vim
fi

echo
echo install wiringPi
if [ -d $WIRING_DIR ]; then
        echo "wireingPi already cloned"
	cd $WIRING_DIR
	git fetch
	LOCAL=$(git rev-parse @{0})
	REMOTE=$(git rev-parse @{u})
	BASE=(git rev-parse @ @{u})
	if [ $LOCAL = $REMOTE ]; then
		echo "up-to-date"
	elif [ $LOCAL = $BASE ]; then
		echo "need to pull"
		git pull origin
		./build
	else
		if [ $REMOTE = $BASE ]; then
			echo "need to push - exit"
		else
			echo "diverged - exit"
		fi
		cd $ACTUAL_DIR
		exit -1
	fi 
else
        echo "clone wireingPi"
	git clone $wwwWireingPi $WIRING_DIR
	cd $WIRING_DIR
	./build
fi

command -v gpio >/dev/null 2>&1
if [ $? -eq 0 ]; then
        echo "wireingPi succsessfully installed!"
else
	read -p "failes to install wireingPi! still continue? [N/y]:" CHOICE
	if [[ $CHOICE != "y" ]]; then
		echo "aborted"
		cd $ACTUAL_DIR
		exit -1;
	fi
fi

echo to show all current gpio usages:
echo gpio readall

cd $ACTUAL_DIR

echo
echo install ledPanel

if [ -d $LEDPANEL_DIR ]; then
        echo "ledPanel already cloned"
        cd $LEDPANELMAKE_DIR
	git fetch
	LOCAL=$(git rev-parse @{0})
        REMOTE=$(git rev-parse @{u})
        BASE=(git rev-parse @ @{u})
        if [ $LOCAL = $REMOTE ]; then
                echo "up-to-date"
        elif [ $LOCAL = $BASE ]; then
                echo "need to pull"
                git pull origin
        else
		if [ $REMOTE = $BASE ]; then
			echo "need to push! - exit"
	        else
        		echo "diverged - exit"
		fi
		cd $ACTUAL_DIR
                exit -1
        fi
else
	git clone $wwwLedPanel $LEDPANEL_DIR
	echo "ledPanel successfully cloned"
        cd $LEDPANELMAKE_DIR
	mkdir obj
fi

make all
if [ $? -eq 0 ]; then
        echo "ledPanel succsessfully compiled!"
else
        read -p "failes to compile! still continue? [N/y]:" CHOICE
        if [[ $CHOICE != "y" ]]; then
                echo "aborted"
		cd $ACTUAL_DIR
                exit -1;
        fi
fi

cd $INSTALL_DIR

#echo change file owners:
chown -cR pi:pi $INSTAL_DIR 

cd $LEDPANELMAKE_DIR

echo
if [ -f $LEDPANELMAKE_DIR/panel_config.xml ]; then
	echo panel_config.xml already there
else	
	rename panel_config.xml with:
	echo
	echo ls $LEDPANELMAKE_DIR
	ls $LEDPANELMAKE_DIR
	echo
	read -p "enter panel_config.xml.NAME extention: " NAME
	if [[ -e $LEDPANELMAKE_DIR/panel_config.xml.example.$NAME ]]; then
		mv $LEDPANELMAKE_DIR/panel_config.xml.example.$NAME $LEDPANELMAKE_DIR/panel_config.xml
	else
		echo "could not find file $LEDPANELMAKE_DIR/panel_config.xml.example.$NAME"
		cd $ACTUAL_DIR
		exit -1
	fi
fi
if [ -d $LEDPANEL_INSTALL_DIR ]; then
	echo
else
	mkdir $LEDPANEL_INSTALL_DIR
fi

#modprobe spi-bcm2708

make install
#make start

cd $ACTUAL_DIR
exit 0
