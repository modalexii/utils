#!/usr/bin/python

# Pull arbitrary sentences from the hipsteripsum "API"
# (If you want to call it that) and tweet them.
#
# Useful as a really simple tweeting machine if the
# hipsteripsum stuff is removed and new tokens added

import twitter
from urllib2 import urlopen
from random import choice

sentences = []
t = urlopen('http://hipsterjesus.com/api?paras=1&type=hipster-centric').read()

# go go gadget shit data parsing:
s = t.split('"')[3][3:][:-5]

for i in s.split('.'):
	sentences.append(i)

r = choice(sentences).strip()
if len(r) > 1:
	r = '%s.' % (r.capitalize())

q = choice(r.split(' '))

r = r.replace(q, '#%s' % (q))

api = twitter.Api(consumer_key='XXXX',
	consumer_secret='XXXX',
	access_token_key='XXXX',
	access_token_secret='XXXX')

api.PostUpdate(r)
