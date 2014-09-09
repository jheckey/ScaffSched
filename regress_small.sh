#!/bin/bash

BIN=$(dirname $0)

for f in $*; do
    b=$(basename $f)
    k=$(perl -e '($n,$s,$k,$d,$x) = split /\./, $ARGV[0]; print $k' ${b})
    d=$(perl -e '($n,$s,$k,$d,$x) = split /\./, $ARGV[0]; print $d' ${b})
    echo Running ${BIN}/sched.pl $f ...
    if [ ! -e ${b}.ss ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n ss -k $k -d $d $f -m > ${b}.ss
    fi
    if [ ! -e ${b}.l1.lpfs ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n lpfs -k $k -l 1 -d $d $f -m > ${b}.l1.lpfs
    fi
    if [ ! -e ${b}.rs.l1.lpfs ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n lpfs -k $k -l 1 -d $d $f -m -opp -refill > ${b}.rs.l1.lpfs
    fi
    if [ ! -e ${b}.o1.d1.s1.rcp ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n rcp -k $k -d $d --op 1 --dist 1 --slack 1 -m $f > ${b}.o1.d1.s1.rcp
    fi
done
