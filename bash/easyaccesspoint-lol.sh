#!/bin/bash
# Fake AP script using aircrack-ng tools and dhcp3-server

#
#
#
# This was practically my first shell script.
# It should not be used for anything, ever, but is here because it makes me laugh.
# It will "probably" actually work in BT4 beta
#
#
#

echo -e "                  
                            \e[1;33m\  /                           
\e[1;34m~ BreezySeas' ~~~~~~~~~~~~ \e[1;33m- \e[1;37m() \e[1;33m- \e[1;34m~~~~~~~~~~~~~~~~~~~~~~~~               
\e[1;37m ______                    \e[1;33m /  \    \e[1;37m                    
|  ____|                     /\                           
| |__    __ _ ___ _   _     /  \   ___  ___  ___ ___ ____
|  __|  / _' / __| | | |   / /\ \ / __|/ __|/ _ | __/ ___|
| |____| (_| \__ \ |_| |  / ____ \ (__| (__|  __|__ \__ \     
|______|\__,_|___/\__, | /_/    \_\___|\___|\___|___/___/    
                   __/ |                          \e[1;34mpre-beta
~~~~~~~~~~~~~~~~~ \e[1;37m|___/ \e[1;34m ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
"                                
echo -e "\e[1;33m
A (relatively) automated way to create an access point with
your wireless NIC, and log connections to it. Based on many
other people's work- in fact, this script does nothing more 
than hold your hand through the use of a few popular tools.

Works with Back|Track, Ubuntu support in the works. \e[00m
"
read -p "This must be run with root priv's. Press any key to start..."
if [[ $EUID != 0 ]]; then
  echo -e "\e[1;31mYou must run this script with root privileges!\e[00m"
  echo "Exiting..."; sleep 1; exit 1
fi
echo
echo "Checking installed packages..."; sleep 1
dpkg -l | grep dhcp3-server
if [ $? != 0 ]; then 
	echo "apt-get install -y dhcp3-server;" >> tmp_install.sh
	dhcpd=MISSING; dhcpd_tablepad=" "
	else dhcpd=OK; dhcpd_tablepad="      "
	# Note that the dhcp3-server installs itself quite
	# differently from distro to distro. This script 
	# puts a lot of effort into running it correctly.
fi
dpkg -l | grep aircrack-ng
if [ $? != 0 ]; then 
	echo "apt-get install -y aircrack-ng;" >> tmp_install.sh
	aircrack=MISSING; aircrack_tablepad=" "
	else aircrack=OK; aircrack_tablepad="      "
fi
dpkg -l | grep iptables
if [ $? != 0 ]; then 
	echo "apt-get install -y iptables;" >> tmp_install.sh
	iptables=MISSING; iptables_tablepad=" "
	else iptables=OK; iptables_tablepad="      "
fi
if [ -e tmp_install.sh -a -s tmp_install.sh ]; then
	echo -e " \e[1;31m
		+---------------------------------+
		| dhcp3-server ....	$dhcpd $dhcpd_tablepad |
		| aircrack-ng  ....	$aircrack $aircrack_tablepad |
		| iptables     ....	$iptables $iptables_tablepad |
		+---------------------------------+ \e[00m
	    " 
	echo; echo
	read -p "Some required packages are missing. Install (Y/n)? "
	if [ "$REPLY" == "y" -o "$REPLY" == "Y" -o "$REPLY" == "" ]; then
		chmod a+x tmp_install.sh
		echo -e "\e[1;33mWaiting for install to finish... \e[00m"
		xterm -title "Installing Dependencies..." -e sh tmp_install.sh
		if [ $? != 0 ]; then 
			echo -e "\e[1;31m INSTALLATION RETURNED ERRORS--------------------! \e[00m"
			echo 'Please make sure you have "dhcp3-server", "aircrack-ng" and "iptables"
 properly installed. Best to exit and run this script again after investigating.'
			read -p "Do you know what you're doing and wish to continue (y/N)? "
				if [ "$REPLY" == "y" -o "$REPLY" == "Y" ]; then 
					echo "Alright then..."; sleep 1
					else echo "No h4x0r'n 4 u :-/"; echo "Exiting..."
					rm tmp_install.sh; sleep 1; exit 0
				fi
			else echo -e " \e[1;32m Done. Everyting seems to be in order. \e[00m "; echo ;
			echo "Will now continue..."
		fi
		rm tmp_install.sh
	fi
fi
echo "
Searching for network interfaces..."
ifconfig | grep eth
if [ $? != 0 ]; then 
	echo -e "\e[1;31m NO ETHERNET INTERFACES FOUND ------------------------! \e[00m"
	echo "No network interfaces named eth<#> were found. This may not be a problem."
	read -p "Continue (Y/n)? "
	if [ "$REPLY" == "n" -o "$REPLY" == "N" ]; then echo "No h4x0r'n 4 u :-/";
		echo "Exiting..."; sleep 1; exit 0
		elif [ "$REPLY" != "" -o "$REPLY" != "y" -o "$REPLY" != "Y" ]; then 
		read -p "Bad input. Look before your leap."; sleep 2; echo "Assuming OK to continue..."
		else echo "Onward and Upward..."
	fi
fi
ifconfig | grep wlan
if [ $? != 0 ]; then 
	echo -e "\e[1;31m NO WIRELESS INTERFACES FOUND ------------------------! \e[00m"
	echo 'This is a fatal problem unless you DO have a wireless card that is simply not named "wlan<#>"'
	read -p "Do you know what you're doing and wish to continue (y/N)? "
	if [ "$REPLY" == "y" -o "$REPLY" == "Y" ]; then echo "Alright then..."; sleep 1
		else echo "No h4x0r'n 4 u :-/"
		echo "Exiting..."; sleep 1; exit 0
	fi
	else echo -e "
\e[1;32mOK \e[00m

"
fi
clear
echo -e "\e[1;34m"
ifconfig | grep -i -e eth -e wlan -A 1
echo -e "\e[1;33mAn abridged ifconfig has been printed above. You're welcome. \e[00m

Please enter:
 "
read -p "Interface currently accessing the internet ( [ENTER] for eth0): "
if [ "$REPLY" != "" ]; then WAN_INT=""$REPLY""; else WAN_INT="eth0"; fi
read -p "Wireless interface to use for the access point ( [ENTER] for wlan0): "
if [ "$REPLY" == "" ]; then WLAN_INT=wlan0; else WLAN_INT="$REPLY"; fi
echo 'SSID (name) of the wireless network to create...
May we suggest something like "FBI Surveillance Van" or "Army Spy Drone"?'
read -p '( [ENTER] for "linksys"): '
if [ "$REPLY" == "" ]; then SSID=linksys; else SSID="$REPLY"; fi
read -p "Channel to operate on ( [ENTER] for ch.9): "
if [ "$REPLY" == "" ]; then CH=9; else CH="$REPLY"; fi
echo "IP address of your local internet gateway"
read -p "(no default choice here): "
if [ "$REPLY" == "" ]; then 
	echo -e "\e[0;31mNO DEFAULT AVAILABLE!\e[00m"
	read -p "IP address of your local internet gateway: "
	if [ "$REPLY" == "" ]; then echo -e "\e[0;31mFAIL\e[00m"; sleep 1; exit 0
		else INET_GW="$REPLY"; 
	fi 
	else INET_GW="$REPLY";
fi
echo -e "
\e[1;33mSwitching $WLAN_INT to monitor mode...\e[00m"
rfkill unblock all
airmon-ng
airmon-ng start $WLAN_INT
if [ $? != 0 ]; then echo -e '\e[1;31m
ERRORS MAY HAVE OCCURRED ------------------------! \e[00m \e[1;33m 
There seem to have been some problems while trying to put your wireless 
interface into monitor mode. Note that not all wireless cards can do 
this. Research your model/chipset and see if it supports "monitor" or 
"promiscuous" mode. \e[00m'
	read -p "Attempt to continue (y/N)? "
	if [ "$REPLY" != "y" -o "$REPLY" != "Y" ]; then echo "No h4x0r'n 4 u :-/";
		echo "Exiting..."; sleep 1; exit 0
		else echo "Alright then..."; echo 
	fi
fi
echo -e "\e[1;34m"
ifconfig | grep -i -e mon -A 1
echo -e '\e[1;33mAn abridged ifconfig has (again) been printed above.\e[00m

Please enter the name of the monitor interface in use (usually the largest
# "mon" interface shown above)
 '
read -p "( [ENTER] for mon0): "
if [ "$REPLY" != "" ]; then MON_INT="$REPLY"; else MON_INT="mon0"; fi
clear
echo -e "\e[1;33m
Starting basic wireless services...\e[00m"
xterm -title "~~ Easy Access ~~" -e airbase-ng -e "$SSID" -c $CH $MON_INT &
AP_PID=$!
if [ $? != 0 ]; then echo -e '\e[1;31m
ERRORS MAY HAVE OCCURRED ------------------------! \e[00m \e[1;33m 
There seem to have been some problems while trying to start the wireless service. 
You may simply need to change which monitor interface you are using (especially
if you have run this script up to this point before...)\e[00m'
	read -p "Attempt to continue (Y/n)? "
	if [ "$REPLY" != "y" -o "$REPLY" != "Y" -o "$REPLY" != "" ]; then echo "No h4x0r'n 4 u :-/";			
		echo "Exiting..."; kill $AP_PID; sleep 1; exit 0
		else read -p "Change monitor interface? (Y/n)? "
			if [ "$REPLY" != "y" -o "$REPLY" != "Y" -o "$REPLY" != "" ]; 
				then echo "Hope you know whay you're doing..."
				else read -p "Monitor interface to use: "; MON_INT="$REPLY"
				echo -e "\e[1;33m
Restarting basic wireless services...\e[00m"
				ifconfig mon0 down; ifconfig mon1 down; ifconfig mon2 down;
				ifconfig at0 down; ifconfig at1 down; ifconfig at2 down;
				rfkill unblock all
				airbase-ng -e "$SSID" -c $CH $MON_INT &
				if [ $? != 0 ]; then echo -e "
\e[1;31mNO DICE.
This is a fatal error at this point... Sorry :-/ \e[00m"
					echo "Exiting..."; kill $AP_PID; sleep 1; exit 1
				fi
			fi
	fi
	else echo -e "
\e[1;32mOK \e[00m
"
fi
disown $AP_PID
echo -e "\e[1;33mWe must now set up IP addressing for the wireless network.\e[00m

Press [ENTER] to use the default 172.16.10.0/24, or
press any other key + [ENTER] to assign the addresses manually"
read -p ""
if [ "$REPLY" == "" ]; then 
	NETMASK=255.255.255.0
	NWORK_IP=172.16.10.0
	ROUTER_IP=172.16.10.1
	BCAST_IP=172.16.10.255
	DHCP_RANGE="172.16.10.100 172.16.10.200"
	else
	read -p "NETWORK address (host bits off): "; NWORK_IP="$REPLY"
	read -p "Subnet mask: "; NETMASK="$REPLY"
	read -p "Gateway IP (Address to give the WNIC): "; ROUTER_IP="$REPLY"
	read -p "BROADCAST address (host bits on): "; BCAST_IP="$REPLY"
	read -p "DHCP range (i.e. 172.16.10.100 172.16.10.200): "; DHCP_RANGE="$REPLY"
	
fi
echo -e "\e[1;33mConfiguring wireless tap interface...\e[00m"
TAP_INT=at0
ifconfig at0 up
ifconfig at0 $ROUTER_IP netmask $NETMASK
if [ $? != 0 ]; then echo -e '\e[1;31m
ERRORS MAY HAVE OCCURRED ------------------------! \e[00m \e[1;33m 
There seem to have been some problems while trying to bring up default 
tap interface at0. You may need to pull down exiting tap interfaces.\e[00m'
	read -p "Attempt to continue (Y/n)? "
	if [ "$REPLY" != "y" -o "$REPLY" != "Y" -o "$REPLY" != "" ]; then echo "No h4x0r'n 4 u :-/"
		echo "Exiting..."; kill $AP_PID; sleep 1; exit 0
		else read -p "Specify different tap interface (y/N)? "
		if [ "$REPLY" == "y" -o "$REPLY" == "Y" ]; then 
			read -p "New tap int name: "; TAP_INT="$REPLY"
			ifconfig at0 down; ifconfig $TAP_INT up
			ifconfig $TAP_INT $ROUTER_IP netmask $NETMASK
		fi
	fi
fi

echo "
Creating DHCP server configuration...

DCHP lease times set to 600 default/7200 max."
read -p "Would you like to change this (y/N)? "
if [ "$REPLY" == "y" -o "$REPLY" == "Y" ]; then
	read -p "Client default lease time: "; DEF_LEASE="$REPLY"
	read -p "Client max lease time: "; MAX_LEASE="$REPLY"
	else DEF_LEASE=600; MAX_LEASE=7200
fi
echo "
DNS server set to 208.67.222.222 (openDNS)."
read -p "Would you like to change this (y/N)? "
if [ "$REPLY" == "y" -o "$REPLY" == "Y" ]; then
	read -p "Primary nameserver: "; NS="$REPLY"
	else NS=208.67.222.222;
fi
echo "
Writing config file..."
touch dhcpd.conf
echo "
# DHCP config file
ddns-update-style ad-hoc;
default-lease-time $DEF_LEASE;
subnet $NWORK_IP netmask $NETMASK {
	option subnet-mask $NETMASK;
	option broadcast-address $BCAST_IP;
	option routers $ROUTER_IP;
	option domain-name-servers $NS;
	range $DHCP_RANGE;
}" >> dhcpd.conf
if [ -e /etc/dhcp3/dhcpd.conf ]; then 
		mv -vf /etc/dhcp3/dhcpd.conf /etc/dhcp3/dhcpd.conf.orig
		DHCP_CONFIG=/etc/dhcp3/dhcpd.conf
		DHCP_START=dhcpd3
		INITD_PATH=/etc/init.d/dhcp3-server
	elif [ -e /etc/dhcp/dhcpd.conf ]; then
		mv -vf /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.orig
		DHCP_CONFIG=/etc/dhcp/dhcpd.conf
		DHCP_START=dhcpd
		INITD_PATH=/etc/init.d/isc-dhcp-server
	elif [ -e /etc/dhcpd/dhcpd.conf ]; then
		mv -vf /etc/dhcpd/dhcpd.conf /etc/dhcpd/dhcpd.conf.orig
		DHCP_CONFIG=/etc/dhcpd/dhcpd.conf
		DHCP_START=dhcpd
		INITD_PATH=/etc/init.d/dhcp3-server
	else echo -e '\e[1;31m
NO DHCP CONFIGURATION FILE FOUND! \e[00m \e[1;33m
Please confirm that dhcp3-server is properly installed. \e[00m'
	read -p "Manually specify location of config file (y/N)? "
	if [ "$REPLY" != "y" -o "$REPLY" != "Y" ]; then echo "No h4x0r'n 4 u :-/";
		echo "Exiting..."; sleep 1; exit 0
		else read -p "FULL PATH to dhcp.conf: "
		DHCP_CONFIG=$REPLY
	fi
fi
echo 'INTERFACES="$WLAN_INT $TAP_INT $MON_INT"' > $INITD_PATH
mv -vf dhcpd.conf $DHCP_CONFIG
sleep 1
route add -net $NWORK_IP netmask $NETMASK gw $ROUTER_IP
if [ -d /var/run/dhcp-server ]; then DHCPD_PID=/var/run/dhcp-server/dhcpd.pid
	elif [ -d /var/run/dhcp3-server ]; then DHCPD_PID=/var/run/dhcp3-server/dhcpd.pid
	elif [ -d /var/run/dhcpd ]; then DHCPD_PID=/var/run/dhcpd/dhcpd.pid
	else mkdir -p /var/run/dhcp3-server; DHCPD_PID=/var/run/dhcp3-server/dhcpd.pid
 fi
chown dhcpd:dhcpd $DHCPD_PID
# chmod 770 $DHCPD_PID
$INITD_PATH status
if [ $? == 0 ]; then $INITD_PATH stop; fi
echo "
Starting DHCP server..."
$DHCP_START -cf $DHCP_CONFIG -pf $DHCPD_PID $TAP_INT
if [ $? != 0 ]; then echo -e '\e[1;31m
ERRORS MAY HAVE OCCURRED ------------------------! \e[00m \e[1;33m 
There seem to have been some problems while trying to start the DHCP server.
Perhaps re-entering the data, paying careful attention to syntax and IP
addressing will remedy the problem...\e[00m'
	read -p "Attempt to continue (Y/n)? "
	if [ "$REPLY" != "y" -o "$REPLY" != "Y" -o "$REPLY" != "" ]; then echo "No h4x0r'n 4 u :-/";
		echo "Exiting..."; kill $AP_PID; sleep 1; exit 0
	fi
fi
echo "
Creating iptables rules..."
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables --table nat --append POSTROUTING --out-interface $WAN_INT -j MASQUERADE
iptables --append FORWARD --in-interface $TAP_INT -j ACCEPT
iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to $INET_GW
echo
if [ -e tmp_install.sh ]; then echo "Cleaning up..."; rm tmp_install.sh; fi
clear
echo -e " \e[1;34m
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 \e[1;33mDONE!\e[1;34m ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\e[00m
Information about anyone who connects to your access point will be 
displayed in the pop-up window.
\e[1;33m
You are using tools from the aircrack-ng suite- it would behoove you 
to learn more about them.
				\e[1;32m	 http://www.aircrack-ng.org/
\e[00m
You can contact \e[0;37m\e[0;37m[\e[00m or just follow :) ]\e[00m me on Twitter \e[1;34m@BreezySeas
\e[00mTODO's for this script are too numerous to list.
\e[1;34m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\e[00m
"
### To Do ########################################
#
# >record all packets with aircrack -F <filename>
# >captive portal
# >upsidedownternet
# >evil dns
# >menu: 1) Set up a soft AP 
#	 2) Have more fun
#
# >flags, see http://www.linuxjournal.com/magazine/work-shell-parsing-command-line-options-getopt
#

