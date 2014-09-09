#!/bin/bash

BIN=$(dirname $0)
OPT=${SCAFFOLD}/build/Release+Asserts/bin/opt
SCAF=${SCAFFOLD}/build/Release+Asserts/lib/Scaffold.so

for f in $*; do
    echo -n "$f: "
    $OPT -load $SCAF -ResourceCount $f 2>&1 > /dev/null | tail -1
    $OPT -load $SCAF -GetCriticalPath $f 2>&1 > /dev/null
done

#BF/bf_x2_y2_inline2M.ll BF/bf_x3_y2_inline2M.ll BWT/bwt_n100_s1000_inline2M.ll BWT/bwt_n300_s3000_inline2M.ll CN/cn_p6_inline2M.ll CN/cn_p8_inline2M.ll Grovers/grovers_n30_inline2M.ll Grovers/grovers_n40_inline2M.ll GSE/gse_m10_inline2M.ll GSE/gse_m30_inline2M.ll SHA1_para/sha1_n128_inline2M.ll SHA1_para/sha1_n128_inline3M.ll SHA1_para/sha1_n448_inline2M.ll SHA1_para/sha1_n448_inline3M.ll Shors/shors_n4_inline2M.ll

