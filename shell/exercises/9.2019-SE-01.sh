#!/bin/bash
 
FILE="/srv/sample-data/01-shell/2019-SE-01/input.data"
type=$(cat $FILE | tail +2 | sort -t ';' -nr -k 3 |head -n 1| cut -d ';' -f 2)
cat $FILE | grep -E "[^;]*;${type};" | sort -t ';' -n -k 3 | head -n 1 | cut -d ';' -f 1,4 | tr ';' '   '
