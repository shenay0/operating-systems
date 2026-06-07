#!/bin/bash

if [ $# -ne 1 ];then
    exit 1
fi


user="$1"
temp=$(mktemp)

while read -r pid rss vsz comm; do
    #num=$(echo "scale=2; ${rss}/${vsz}" | bc )
    num=$(awk -v rss="$rss" -v vsz="$vsz" 'BEGIN { printf "%.2f", rss/vsz }')
    echo "${pid} ${comm} ${vsz} ${num}" >> "$temp"
done < <(ps -u "$user" -o pid=,rss=,vsz=,comm=)


sort -nr -t ' ' -k3 "$temp"
