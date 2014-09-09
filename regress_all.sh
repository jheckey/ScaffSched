#!/bin/bash

BIN=$(dirname $0)

for f in $*; do
    b=$(basename $f)
    k=$(perl -e '($n,$s,$k,$d,$x) = split /\./, $ARGV[0]; print $k' ${b})
    d=$(perl -e '($n,$s,$k,$d,$x) = split /\./, $ARGV[0]; print $d' ${b})
    echo Running ${BIN}/sched.pl $f ...
    if [ ! -e ${b}.ss ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n ss -k $k -d $d $f -a > ${b}.ss
    fi
    if [ "$k" -eq "1" ]; then
        if [ ! -e ${b}.l0.lpfs ]; then
            /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n lpfs -k $k -l 0 -d $d $f -a > ${b}.l0.lpfs
        fi
    fi
    for (( l=1; l < k; l++ )); do
        if [ ! -e ${b}.l${l}.lpfs ]; then
            /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n lpfs -k $k -l $l -d $d $f -a > ${b}.l${l}.lpfs
        fi
        #${BIN}/sched.pl -n lpfs -k $k -l $l -d $d $f -a -refill > ${b}.r.l${l}.lpfs
        if [ ! -e ${b}.s.l${l}.lpfs ]; then
            /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n lpfs -k $k -l $l -d $d $f -a -opp > ${b}.s.l${l}.lpfs
        fi
        if [ ! -e ${b}.rs.l${l}.lpfs ]; then
            /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n lpfs -k $k -l $l -d $d $f -a -opp -refill > ${b}.rs.l${l}.lpfs
        fi
    done
    if [ ! -e ${b}.o1.d1.s1.rcp ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n rcp -k $k -d $d --op 1 --dist 1 --slack 1 -a $f > ${b}.o1.d1.s1.rcp
    fi
    if [ ! -e ${b}.o10.d1.s1.rcp ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n rcp -k $k -d $d --op 10 --dist 1 --slack 1 -a $f > ${b}.o10.d1.s1.rcp
    fi
    if [ ! -e ${b}.o1.d10.s1.rcp ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n rcp -k $k -d $d --op 1 --dist 10 --slack 1 -a $f > ${b}.o1.d10.s1.rcp
    fi
    if [ ! -e ${b}.o1.d1.s10.rcp ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ${BIN}/sched.pl -n rcp -k $k -d $d --op 1 --dist 1 --slack 10 -a $f > ${b}.o1.d1.s10.rcp
    fi
done
