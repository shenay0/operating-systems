#!/bin/bash

if [ $# -lt 1 ];then
    exit 1
fi

temp=$(mktemp)
N=10
if [[ "$1" == '-n' ]];then
    if [[ $# -lt 3 ]];then
        exit 2
    fi
    N="$2"
    shift 2
fi

for arg in "${@}"; do
    if [ -f "$arg" ]; then
        bn=$(basename "$arg")
        name="${bn%.*}"

        while IFS=' ' read -r date time data; do
            echo "${date} ${time} ${name} ${data}" >> "$temp"
        done < <(cat "$arg" | tail -n "$N")
    fi

done

sort  -k1,1 -k2,2 "$temp"

rm "$temp"
