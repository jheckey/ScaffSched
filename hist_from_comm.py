#!/usr/bin/env python

import sys
inputFile = open(sys.argv[1], 'r')
linelist = inputFile.read().splitlines()
hist = []
list = []
for line in linelist:
        list = line.split()
        for i in range (len(list)):
                if i >=7:
                        hist.append(list[i])
outputFile = open('histogram.'+str(sys.argv[1]), 'w+')
outputFile.write(' '.join(str(x) for x in hist))
