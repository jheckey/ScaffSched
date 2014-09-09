#!/usr/bin/env python

import sys
import re
import collections

last = collections.defaultdict(list)
keys = ['Function', 'SIMDs', 'ts', 'ots', 'mts', 'moves', 'tgates', 'mlist']

for file in sys.argv[1:]:
	algo = ''
	cfg = ''
	ext = ''
	k = 0
	d = 0
	m = re.search('([a-zA-Z0-9]+)_(\w+).simd.(\d).(\d+).leaves.(.*)', file)
	if ( m ):
		algo = m.groups(1)[0]
		cfg = m.groups(1)[1]
		k = m.groups(1)[2]
		d = m.groups(1)[3]
		ext = m.groups(1)[4]
		comm = "comm_aware_schedule.txt." + algo + "_" + cfg + "_K" + k + "_D" + d + "_" + ext
		print (file + " -> " + comm ) 
		COM = open(comm, 'a')
		RES = open(file, 'r')
		last['Function'] = []
		for line in RES:
			n = re.search('^Function: (\w+)', line)
			if( n ):
				if (last['Function'] != []):
					for k in keys:
						if(last[k] != []):
							COM.write(str(last[k]) + " ")
					COM.write("\n")
				last['Function'] = n.groups(1)[0]
			w = re.search('^(SIMDs|ts|ots|mts|moves|tgates|mlist) = (.+)', line)
			if (w):
				last[w.groups(1)[0]] = w.groups(1)[1]

		for k in keys:
			if(last[k] != []):
				COM.write(str(last[k]) + " ")		
		COM.write("\n")
		COM.close
		RES.close				
		
