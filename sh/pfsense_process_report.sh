# Intended to replicate the Service Status dashboard in an email report from
# pfsense, but the idea could be used in countless ways. Join all lines or
# make a script (this hides the command itself from the report, which is nice).
# Brackets in grep remove grep itself from the output so -q works as intended.
p=$(ps ax);
echo "$(echo $p | grep -q '[s]bin/dhcpd' && echo ✓ || echo '❌')  DHCP Service";
echo "$(echo $p | grep -q '[b]in/dpinger' && echo ✓ || echo '❌')  Gateway Monitoring Daemon)";
echo "$(echo $p | grep -q '[s]bin/ntpd' && echo ✓ || echo '❌')  NTP clock sync";
echo "$(echo $p | grep -q '[s]bin/openvpn' && echo ✓ || echo '❌')  OpenVPN server";
echo "$(echo $p | grep -q '[b]in/snort' && echo ✓ || echo '❌')  Snort IDS/IPS Daemon";
echo "$(echo $p | grep -q '[s]bin/unbound' && echo ✓ || echo '❌')  DNS Resolver";