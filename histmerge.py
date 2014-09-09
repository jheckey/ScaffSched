#!/usr/bin/env python
import sys

inputFile = open(sys.argv[1], 'r')
outputFile = open('BoundaryHistogram.txt', 'a')
outputFile.write('\n' + str(sys.argv[1]) + '\n' + inputFile.read())
