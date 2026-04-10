#!/bin/bash
 
file="/srv/sample-data/01-shell/2020-SE-02/spacex.txt"
site=$(cat $file | tail -n +2| \
awk -F '|' '$3=="Failure" {array[$2]+=1} END{for (key in array) {print key, array[key]}} '\
| sort -nr -k 2 | cut -d ' ' -f 1)
tail -n +2 $file | grep "$site" | sort -n -k 1 | tail -n 1 | cut -d '|' -f 2-4 | tr '|' ':' 


