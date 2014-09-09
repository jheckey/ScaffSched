#!/bin/bash

DIR=`date +%Y-%m-%d-%H:%M`
mkdir -p $DIR

for f in */*.plot; do
    b=$(basename $f)
    d=$(basename $(dirname $f))
    # Only print header if file hasn't been created yet
    if [ -e ${DIR}/${b} ]; then
        awk "!/Config/ {print \"${d}/\"\$0}" $f >> ${DIR}/${b}
    else
        awk "m = !/Config/ {print \"${d}/\"\$0} !m {print \$0}" $f > ${DIR}/${b}
    fi
done
