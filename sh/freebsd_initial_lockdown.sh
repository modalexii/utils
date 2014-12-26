rc_conf()
{
	echo "Adding rc.conf stuff..." \
	&& echo 'syslogd_flags="-ss"' >> /etc/rc.conf \
	&& echo 'icmp_drop_redirect="YES"' >> /etc/rc.conf \
	&& echo 'sendmail_enable="NO"' >> /etc/rc.conf \
	&& echo 'clear_tmp_enable="YES"' >> /etc/rc.conf 
}

sysctl_conf()
{
	   echo "Adding sysctl.conf stuff..." \
	&& echo 'security.bsd.see_other_uids=0' >> /etc/sysctl.conf \
	&& echo 'net.inet.ip.random_id=1' >> /etc/sysctl.conf \
	&& echo 'net.inet.tcp.always_keepalive=1' >> /etc/sysctl.conf \
	&& echo 'net.inet.tcp.blackhole=2' >> /etc/sysctl.conf \
	&& echo 'net.inet.udp.blackhole=1' >> /etc/sysctl.conf \
	&& echo 'kern.ipc.somaxconn=1024' >> /etc/sysctl.conf \
	&& echo 'net.inet.tcp.sendspace=32768' >> /etc/sysctl.conf \
	&& echo 'net.inet.tcp.recvspace=32768' >> /etc/sysctl.conf \
	&& echo 'net.link.ether.inet.max_age=1200' >> /etc/sysctl.conf \
	&& echo 'net.inet.icmp.bmcastecho=0' >> /etc/sysctl.conf \
	&& echo 'net.inet.ip.redirect=0' >> /etc/sysctl.conf \
	&& echo 'net.inet.ip6.redirect=0' >> /etc/sysctl.conf \
	&& echo 'net.inet.icmp.maskrepl=0' >> /etc/sysctl.conf \
	&& echo 'net.inet.ip.sourceroute=0' >> /etc/sysctl.conf \
	&& echo 'net.inet.ip.accept_sourceroute=0' >> /etc/sysctl.conf 
}

file_perms()
{
	   echo "Changing file permissions && allow cron for root..." \
	&& chmod o= /etc/fstab \
	&& chmod o= /etc/ftpusers \
	&& chmod o= /etc/group \
	&& chmod o= /etc/hosts \
	&& chmod o= /etc/hosts.allow \
	&& chmod o= /etc/hosts.equiv \
	&& chmod o= /etc/hosts.lpd \
	&& chmod o= /etc/inetd.conf \
	&& chmod o= /etc/login.access \
	&& chmod o= /etc/login.conf \
	&& chmod o= /etc/newsyslog.conf \
	&& chmod o= /etc/rc.conf \
	&& chmod o= /etc/ssh/sshd_config \
	&& chmod o= /etc/sysctl.conf \
	&& chmod o= /etc/syslog.conf \
	&& chmod o= /etc/ttys \
	&& chmod o= /etc/crontab \
	&& chmod o= /usr/bin/crontab \
	&& chmod o= /usr/bin/at \
	&& chmod o= /usr/bin/atq \
	&& chmod o= /usr/bin/atrm \
	&& chmod o= /usr/bin/batch \
	&& chmod 710 /root \
	&& chmod o= /var/log 
}

cron()
{
	   echo "root" > /var/cron/allow \
	&& echo "root" > /var/at/at.allow 
}

tmp_space()
{
	   rm -rf /tmp \
	&& mkdir /tmp \
	&& rm -rf /var/tmp \
	&& mkdir /var/tmp \
	&& mount -t tmpfs -o rw,nosuid,noexec,mode=01777 tmpfs /tmp \
	&& mount -t tmpfs -o rw,nosuid,noexec,mode=01777 tmpfs /var/tmp \
	&& echo "tmpfs	/tmp	tmpfs	rw,nosuid,noexec,mode=01777	0	0" >> /etc/fstab \
	&& echo "tmpfs	/var/tmp	tmpfs	rw,nosuid,noexec,mode=01777	0	0" >> /etc/fstab
}

update() {
	   freebsd-update fetch \
	&& freebsd-update install
}