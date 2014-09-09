#!/bin/bash

for f in comm_aware_schedule.txt.*; do python hist_from_comm.py $f; done
for f in histogram.comm_aware_schedule.txt.*; do python histbin.py $f; done
for f in sort.histogram.comm_aware_schedule.*; do python histmerge.py $f; done 
