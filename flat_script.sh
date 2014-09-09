#!/bin/bash

BIN=$(dirname $0)
OPT=${SCAFFOLD}/build/Release+Asserts/bin/opt
SCAF=${SCAFFOLD}/build/Release+Asserts/lib/Scaffold.so

plot () {
    local f=$1
    local offset=$2
    local b=$(basename $f .plot)
    local out="${b}.png"
    local cols=$(head -1 $f | wc -w)
    local len=$(wc -l $f | awk '{print $1}')
    local width=0
    (( width = (($len - 1) * $cols) * 3 + 100 ))
    echo gnuplot -e "width='${width}'; yoffset='${offset}'; cols='${cols}'; out='${out}'; datafile='${f}'" graph.plg
    gnuplot -e "width='${width}'; yoffset='${offset}'; cols='${cols}'; out='${out}'; datafile='${f}'" graph.plg
}

for f in $*; do
    b=$(basename $f .scaffold)
    d=1024
    if [ -e ${b}.inlining_info.txt ]; then
        cp ${b}.inlining_info.txt inlining_info.txt
    fi
    if [ -n ${b}.ll ]; then
        # Generate compiled files
        echo Compiling ${f} ...
        ~jheckey/qarc/master/scaffold.sh -r $f
        mv ${b}11.ll ${b}11.ll.keep_me
        #~jheckey/qarc/master/scaffold.sh -c $f
        # Keep the final output for the compilation
        mv ${b}11.ll.keep_me ${b}.ll
    fi
done
for f in $*; do
    b=$(basename $f .scaffold)
    d=1024
    echo Flattening $b ...
    $OPT -S -load $SCAF -ResourceCount2 ${b}.ll > /dev/null 2> ${b}.out
    python ${BIN}/gen-flattening-files.py ${b} > /dev/null
    for i in ${b}_inline2M.txt; do
        cp ${i} inlining_info.txt
        $OPT -S -load $SCAF -InlineModule -dce -internalize -globaldce ${b}.ll -o ${b}_inline2M.ll
        for k in 1 2 3 4; do
            echo $b: Gen SIMD K=$k
            $OPT -load $SCAF -GenSIMDSchedule -simd-kconstraint $k -simd-dconstraint $d ${b}_inline2M.ll > /dev/null 2> ${b}_inline2M.simd.${k}.${d}
            ${BIN}/leaves.pl ${b}_inline2M.simd.${k}.${d} > ${b}_inline2M.simd.${k}.${d}.leaves
		done
    done
done
for f in $*; do
    b=$(basename $f .scaffold)
    echo Getting resource counts ...
    $OPT -S -load $SCAF -ResourceCount ${b}_inline2M.ll > /dev/null 2> ${b}_inline2M.res
done
for f in $*; do
    b=$(basename $f .scaffold)
    ${BIN}/regress_all.sh ${b}*.leaves
done
for f in $*; do
    b=$(basename $f .scaffold)
    ${BIN}/comm_aware.pl ${b}*.ss ${b}*.lpfs ${b}*.rcp
done
for f in $*; do
    b=$(basename $f .scaffold)
    for c in comm_aware_schedule.txt.${b}_*; do
        k=$(perl -e '$ARGV[0] =~ /_K(\d)/; print $1' $c)
        d=$(perl -e '$ARGV[0] =~ /_D(\d+)/; print $1' $c)
        x=$(perl -e '$ARGV[0] =~ /.*_(.+)/; print $1' $c)
        echo Full sched: ${b}_inline2M.simd.${k}.${d}.${x}.time
        cp $c comm_aware_schedule.txt
        if [ ! -e ${b}_inline2M.simd.${k}.${d}.${x}.time ]; then
            $OPT -load $SCAF -GenCGSIMDSchedule -simd-kconstraint-cg $k -simd-dconstraint-cg $d ${b}_inline2M.ll > /dev/null 2> ${b}_inline2M.simd.${k}.${d}.${x}.time
        fi
        # Now do 0-communication cost
        if [ ! -e ${b}_inline2M.simd.${k}.${d}.w0.${x}.time ]; then
            $OPT -load $SCAF -GenCGSIMDSchedule -move-weight-cg 0 -simd-kconstraint-cg $k -simd-dconstraint-cg $d ${b}_inline2M.ll > /dev/null 2> ${b}_inline2M.simd.${k}.${d}.w0.${x}.time
        fi
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
#plot runtime.plot 1e8
#plot avg.plot 1
#plot peak.plot 1
