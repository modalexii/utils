#!/bin/bash

#
# help config a Raspbian Lite image to boot TTY1 straight to a looping gif
#


echo "Checking priviledges"
if [ $(id -u) -ne 0 ]; then
    echo "[!] You must run this as root!" 2>&1
    exit 1
fi

# this is lazy, requires interaction, look how many fucks I give:
echo "We are going to run raspi-config. Change Boot Options to auto-login to the terminal, and whichever other changes you wish. Exit without reboot."
sleep 5
raspi-config

echo "Installing packages - go make a sandwich"
apt-get update -y
apt-get upgrade -y
apt-get install -y --no-install-recommends xserver-xorg xinit
apt-get install -y gifsicle

echo "Updating .xinitrc"
echo "/usr/bin/gifview --animate --geometry 2000x1000 --no-interactive /home/pi/snow.gif" >> ~/.xinitrc

echo "Updating .bash_profile"
echo "# start the x server if we are in TTY1" >> ~/.bash_profile
echo "if [ $(ps ax | grep $$ | grep -v grep | awk '{print $2}') == 'tty1' ]" >> ~/.bash_profile
echo "    then exec startx" >> ~/.bash_profile
echo "fi" >> ~/.bash_profile

#echo "Disabling networking - you will need to start the service after the boot"
#update-rc.d networking disable

echo "Rebooting in 10 seconds - ^c now or forever hold your peace"
sleep 10
reboot