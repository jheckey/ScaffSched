#!/bin/bash

BIN=..
OPT=${SCAFFOLD}/build/Release+Asserts/bin/opt
SCAF=${SCAFFOLD}/build/Release+Asserts/lib/Scaffold.so

for DIR in BWT CN Grovers GSE SHA1_para Shors TFP; do
#for DIR in BF ; do
    cd $DIR
    mkdir -p rcp_bak
    mv -f *rcp.time comm*rcp rcp_bak
    echo $DIR:

    for f in *.scaffold; do
        echo Comm: $f
        b=$(basename $f .scaffold)
        ${BIN}/comm_aware.pl ${b}*.rcp
    done
    for f in *.scaffold; do
        b=$(basename $f .scaffold)
        for c in comm_aware_schedule.txt.${b}_*.rcp; do
            k=$(perl -e '$ARGV[0] =~ /_K(\d)/; print $1' $c)
            d=$(perl -e '$ARGV[0] =~ /_D(\d+)/; print $1' $c)
            x=$(perl -e '$ARGV[0] =~ /.*_(.+)/; print $1' $c)
            i=$(perl -e '$ARGV[0] =~ /inline(.)M/; print $1' $c)
            echo Full sched: ${b}_inline${i}M.simd.${k}.${d}.${x}.time
            cp $c comm_aware_schedule.txt
            $OPT -load $SCAF -GenCGSIMDSchedule -simd-kconstraint-cg $k -simd-dconstraint-cg $d ${b}_inline${i}M.ll > /dev/null 2> ${b}_inline${i}M.simd.${k}.${d}.${x}.time

            # Now do 0-communication cost
            $OPT -load $SCAF -GenCGSIMDSchedule -move-weight-cg 0 -simd-kconstraint-cg $k -simd-dconstraint-cg $d ${b}_inline${i}M.ll > /dev/null 2> ${b}_inline${i}M.simd.${k}.${d}.w0.${x}.time
        done
    done

    rm -f runtime avg
    awk '/^SIMD k=.* main / {print FILENAME,$6 >> "runtime"
                             if ( $8 == 0 )
                                 average = 0
                             else
                                 average = $7/$8
                             print FILENAME,average >> "avg"}' *.time
    ${BIN}/sort.pl runtime > runtime.plot
    ${BIN}/sort.pl avg > avg.plot
    grep "Peak load" *.ss *.lpfs *.rcp | sed 's/:Peak load = / /' | ${BIN}/sort.pl -p > peak.plot

    cd -
done
