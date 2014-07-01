#!/bin/bash

helptext() {
	/bin/echo -e "
Usage: icmppktloss \<remote_host\> \<interval\>

This script sends three paralell ICMP ECHO requests to \`remote_host\`
every \`interval\` seconds and reports the packet loss.

Depends: bash >= v4, cut, date, echo, ping, sleep

e.g., icmppktloss 8.8.8.8 4
e.g., icmppktloss example.com .5
	"
}

[[ $@ ]] || { helptext; exit 1; }

declare -ri starttime=$(/bin/date +"%s")
declare -r rhost=$1
declare -ir interval=$2
declare -i loss=0

getloss() {
	loss=$(/bin/echo $(/bin/ping -qn -W 1 -l 3 -c 3 "$rhost" | /bin/grep \
	 loss | /usr/bin/cut -d' ' -f 6 | /usr/bin/cut -d'%' -f 1)) > /dev/null
}

loop() {
	while [[ 1 ]]; do
		local -i iteration+=1
		getloss
		local -i losstally=$((losstally+loss))
		local -i meanloss=$(($losstally/$iteration))
		local -i now=$(/bin/date +"%s")
		local -i elapsedminutes=$((($now-$starttime)/60))
		/bin/echo [$(/bin/date +"%T")] iter "$iteration", "$loss"% loss, \
		 "$meanloss"% mean loss over "$elapsedminutes" mins
		/bin/sleep "$interval"
	done
}

loop
