#!/bin/bash

for f in $*; do
    b=$(basename $f | sed 's/leaves_.*/leaves/')
    k=$(perl -e '($n,$s,$k,$d,$x) = split /\./, $ARGV[0]; print $k' ${b})
    d=$(perl -e '($n,$s,$k,$d,$x) = split /\./, $ARGV[0]; print $d' ${b})
    echo Running ./sched.pl $f ...
    /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n ss -k $k -d $d $f -m >> ${b}.ss
    if [ "$k" -eq "1" ]; then
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n lpfs -k $k -l 0 -d $d $f -m >> ${b}.l0.lpfs
    fi
    for (( l=1; l < k; l++ )); do
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n lpfs -k $k -l $l -d $d $f -m >> ${b}.l${l}.lpfs
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n lpfs -k $k -l $l -d $d $f -m -opp >> ${b}.s.l${l}.lpfs
        /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n lpfs -k $k -l $l -d $d $f -m -opp -refill >> ${b}.rs.l${l}.lpfs
    done
    /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n rcp -k $k -d $d --op 1 --dist 1 --slack 1 -m $f >> ${b}.o1.d1.s1.rcp
    /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n rcp -k $k -d $d --op 10 --dist 1 --slack 1 -m $f >> ${b}.o10.d1.s1.rcp
    /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n rcp -k $k -d $d --op 1 --dist 10 --slack 1 -m $f >> ${b}.o1.d10.s1.rcp
    /usr/bin/time -f "\t%E real,\t%U user,\t%S sys:\t%C" ~/qarc/layout/sched.pl -n rcp -k $k -d $d --op 1 --dist 1 --slack 10 -m $f >> ${b}.o1.d1.s10.rcp
done
