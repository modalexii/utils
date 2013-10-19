#!/bin/bash

# Offer options for turning off each running virtual machine

for i in `vboxmanage list runningvms | cut -d' ' -f -1`; do
	echo -e "\n[>] $i is running."
	read -p "savestate, poweroff, or pass? "
	# remove quotes from vm name - causes vbox not found error
	i=`echo $i | tr -d '"'`
	if [[ $REPLY == 'savestate' ]]; then
		vboxmanage controlvm $i savestate
		if [[ $? == 0 ]]; then echo 'OK!'; fi
	elif [[ $REPLY == 'poweroff' ]]; then
		vboxmanage controlvm $i poweroff
		if [[ $? == 0 ]]; then echo 'OK!'; fi
	elif [[ $REPLY == 'pass' ]]; then
		echo 'OK...'
	else echo '[!] BAD REPLY'
	fi
done
