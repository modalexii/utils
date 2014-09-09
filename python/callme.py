'''
(ab)uses wheresmycellphone.com to call a phone
'''

import urllib2,urllib,sys,time

def usage():
	print '''
Dials a phone number at specified intervals forever (until ctrl+c).

Usage: callme.py <number> <delay>
E.G.:  callme.py 3015551234 90

Number: A phone number, no punctuation or spaces
 Delay: How many seconds between call attempts (recommend 70 seconds or more
        to allow ring out)
	'''

def call_forever(number,wait):
	'''
	Dial NUMBER every WAIT seconds, forever, unless
	we get 4 non-OK responses from the server
	'''

	http_non_200 = 0

	while True:

		if http_non_200 > 3:
			"print [!] too many bad reesponses from server - aborting"
			break

		query_args = { 
			"noArea" : number[:3],
			"noNumb" : number[3:],
			"noWhen" : 0,
		}

		data = urllib.urlencode(query_args)
		request = urllib2.Request("http://www.wheresmycellphone.com", data)
		response = urllib2.urlopen(request)

		if response.getcode() != 200:
			print "[!] non-OK response from server"
			http_non_200 += 1
		else:
			print "[i] successfully called %s" % number

		print "[i] sleeping for %s seconds" % wait
		time.sleep(wait)

def main():
	if len(sys.argv) == 1:
		usage()
	else:
		number = unicode(sys.argv[1])
		wait = int(sys.argv[2])
		call_forever(number,wait)

if __name__ == "__main__":
	main()