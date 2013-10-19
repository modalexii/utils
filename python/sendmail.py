# import this to send mail

# no syntax or idiot checking
# usr 		= 'username@domain.com'
# pwd 		= 'sw33tpassw0rd'
# host 		= 'smtp.domain.com'
# port		= '587'
# starttls 	= 'y' | 'n'
# fromaddr 	= 'username@domain.com'
# toaddr 	= 'recip@whatever.com'
# subj		= 'Read Me!'
# msg 		= 'This is some message'

from smtplib import SMTP

def send(usr, pwd, host, port, starttls, fromaddr, toaddr, subj, msg):

	server = SMTP('%s:%s' % (host, port))
	if starttls == 'y':
		server.starttls()
	server.login(usr,pwd)
	server.sendmail(fromaddr, toaddr, 'Subject: %s\n\n%s' % (subj, msg))
	server.quit() 
