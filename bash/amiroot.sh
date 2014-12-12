echo "Checking priviledges..."
if [ `id -u` -ne 0 ]; then
	echo "[!] You must run this with root privs! Exiting..." 2>&1
	exit 1
else
	echo "[+] Ok!"
fi
