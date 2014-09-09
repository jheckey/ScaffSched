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

#for f in $*; do
#    b=$(basename $f .scaffold)
#    d=1024
#    if [ -n ${b}.ll ]; then
#        # Generate compiled files
#        ~jheckey/qarc/master/scaffold.sh -r $f
#        mv ${b}11.ll ${b}11.ll.keep_me
#        ~jheckey/qarc/master/scaffold.sh -c $f
#        # Keep the final output for the compilation
#        mv ${b}11.ll.keep_me ${b}.ll
#    fi
#done
#$OPT -load $SCAF -GetCriticalPath sha1_n128_inline2M.ll > /dev/null 2> sha1_para_inline2M_crit_path.txt
#$OPT -load $SCAF -GetCriticalPath sha1_n128_inline3M.ll > /dev/null 2> sha1_para_inline3M_crit_path.txt
#$OPT -load $SCAF -CriticalResourceCount sha1_n128_inline2M.ll > /dev/null 2> sha1_para_inline2M_resources.txt
#$OPT -load $SCAF -CriticalResourceCount sha1_n128_inline3M.ll > /dev/null 2> sha1_para_inline3M_resources.txt
#for f in $*; do
#    b=$(basename $f .scaffold)
#    d=1024
#    for k in 1 2 3 4; do
#        echo $b: Gen SIMD K=$k
#        if [ ! -e ${b}_inline2M.simd.${k}.${d}.leaves ]; then
#            $OPT -load $SCAF -GenSIMDSchedule -simd-kconstraint $k -simd-dconstraint $d ${b}_inline2M.ll > /dev/null 2> ${b}_inline2M.simd.${k}.${d}
#            ${BIN}/leaves.pl ${b}_inline2M.simd.${k}.${d} > ${b}_inline2M.simd.${k}.${d}.leaves
#        fi
#    done
#done
#for f in $*; do
#    b=$(basename $f .scaffold)
#    ${BIN}/regress.sh ${b}*.leaves
#done
#for f in $*; do
#    b=$(basename $f .scaffold)
#    ${BIN}/comm_aware.pl ${b}*.ss ${b}*.lpfs ${b}*.rcp
#done
#for f in $*; do
#    b=$(basename $f .scaffold)
#    for c in comm_aware_schedule.txt.${b}_*; do
#        k=$(perl -e '$ARGV[0] =~ /_K(\d)/; print $1' $c)
#        d=$(perl -e '$ARGV[0] =~ /_D(\d+)/; print $1' $c)
#        x=$(perl -e '$ARGV[0] =~ /.*_(.+)/; print $1' $c)
#        echo Full sched: ${b}_inline2M.simd.${k}.${d}.${x}.time
#        cp $c comm_aware_schedule.txt
#        if [ ! -e ${b}_inline2M.simd.${k}.${d}.${x}.time ]; then
#            $OPT -load $SCAF -GenCGSIMDScheduleOpt -simd-kconstraint-cg $k -simd-dconstraint-cg $d ${b}_inline2M.ll > /dev/null 2> ${b}_inline2M.simd.${k}.${d}.${x}.time
#        fi
#
#        # Now do 0-communication cost
#        if [ ! -e ${b}_inline2M.simd.${k}.${d}.w0.${x}.time ]; then
#            $OPT -load $SCAF -GenCGSIMDSchedule -move-weight-cg 0 -simd-kconstraint-cg $k -simd-dconstraint-cg $d ${b}_inline2M.ll > /dev/null 2> ${b}_inline2M.simd.${k}.${d}.w0.${x}.time
#        fi
#    done
#done
#
#       # Add renaming here
#        mv histogram_data.txt histogram_${b}_inline2m.simd.${k}.${d}.${x}.txt
#
#rm -f runtime avg
#awk '/^SIMD k=.* main / {print FILENAME,$6 >> "runtime"
#                         if ( $8 == 0 )
#                             average = 0
#                         else
#                             average = $7/$8
#                         print FILENAME,average >> "avg"}' *.time
#${BIN}/sort.pl runtime > runtime.plot
#${BIN}/sort.pl avg > avg.plot
#grep "Peak load" *.ss *.lpfs *.rcp | sed 's/:Peak load = / /' | ${BIN}/sort.pl -p > peak.plot
#plot runtime.plot 1e8
#plot avg.plot 1
#plot peak.plot 1
