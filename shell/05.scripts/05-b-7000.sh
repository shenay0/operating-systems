#!/bin/bash


if [ $# -lt 1 ]; then
    exit 1
fi

read -r str

for arg in "$@"; do
    file="$arg"
    count=0
    while read -r line; do
        if echo "$line" | grep -qE ".*${str}.*";then
            count=$((count+1))
        fi
    done < "$file"

    echo "${file}   ${count}"
done
