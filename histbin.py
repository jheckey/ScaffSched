#!/usr/bin/env python

import sys
import numpy as np
a = np.fromfile(open(sys.argv[1], 'r'), sep=' ')
bins = [0, 1, 2, 3, 4, 16, 26, 36, 46, 56, 65, 1000000000]
hist,bin_edges=np.histogram(a,bins=bins)
#print '4' + ',' + '15' + ',' + '25' + ',' + '35' + ',' + '45' + ',' + '55' + ',' + '65' + ',' + '66'
#print ','.join(str(x) for x in hist)
outputFile = open('sort.'+str(sys.argv[1]), 'a')
outputFile.write(','.join(str(x) for x in hist))
