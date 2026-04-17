i#!/bin/bash

temp=$(mktemp)
count=0
while true; do
    data=$(ps -e -o comm=,rss= | awk ' {arr[$1]+=$2} END {for (i in arr ) {print i, arr[i]}}' | sort -t ' ' -k 2 -nr)


    if [[ $(echo "$data" | head -n 1 | cut -d ' ' -f 2) -le 65536 ]]; then
        break;
    fi

    count=$((count+1))

    while read -r cmd rss; do
        if [[ "$rss" -gt 65536 ]]; then
            echo "$cmd" >> "$temp"
        fi

    done < <(echo "$data")
    sleep 1

done

half=$(echo "${count}/2"|bc)
sort "$temp" | uniq -c | awk -v h="$half" ' $1 >= h {print $2}'
rm "$temp"
