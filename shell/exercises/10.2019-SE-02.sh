#!/bin/bash

FILE=/etc/passwd

find $(grep 'SI' ${FILE} |\
cut -d ':' -f 6) -maxdepth 0 -printf "%C@ %p\n" | \
awk '$1>=1775606400 && $1<=1775779200 {print $2}' | sed 's/\/home\/students\/s0//g' | \
xargs -I{} grep {} ${FILE} | cut -d ':' -f 1,5 | sed 's/s0//g' | sed 's/,,,,SI//g' | tr ':' '\t'
