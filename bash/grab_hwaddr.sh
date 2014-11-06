# Grab the MAC address of a device immediately across a link, e.g. a router, NAS unit or other computer plugged directly in to the system on which this is run. Also documents the regex used to pull only MAC addresses from the output of arping.

MAC=$(arping -f -D 0.0.0.0 | grp -Po '(?<=\[).*(?=\])')
