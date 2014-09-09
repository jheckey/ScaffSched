#!/bin/bash

BIN=$(dirname $0)/..
DIR=`date +%Y-%m-%d-%H:%M`
#DIR=tmp; rm -rf tmp
mkdir -p $DIR

cd $DIR
for d in BF BWT CN Grovers GSE SHA1_para Shors TFP/FlexibleBoundaries/n5/WithChange TFP/FlexibleBoundaries/n10/WithChange ; do
    d="$BIN/$d"
    echo Getting numbers for $d
    echo "   awk"
    for f in ${d}/*.time; do
        echo $f
        awk '/^SIMD k=.* main / {print FILENAME,$6 >> "runtime"
                                 if ( $8 == 0 )
                                     average = 0
                                 else
                                     average = $7/$6
                                 print FILENAME,average >> "avg"}' $f
    done
    echo "   grep"
    grep "Peak load" ${d}/*.ss ${d}/*.lpfs ${d}/*.rcp | sed 's/:Peak load = /	/' >> peak
done
${BIN}/sort2.pl -l runtime > runtime.plot
${BIN}/sort2.pl -l avg > avg.plot
${BIN}/sort2.pl -l -p peak > peak.plot
cd -

