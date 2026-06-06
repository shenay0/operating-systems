#!/bin/bash

if [ $# -ne 1 ]; then
    exit 1
fi

if [ ! -d "$1" ]; then
    exit 1
fi

dir="$1"

while read -r line; do
    name=$(echo "$line" | cut -f2)
    bn=$(basename "$name")

    if [ -f "$name" ]; then
        bytes=$(echo "$line" | cut -f1)

        echo "${bn}   (${bytes} bytes)"

    elif [ -d "$name" ]; then
        count=$(find "$name" -mindepth 1 -maxdepth 1 | wc -l)

        echo "${bn}   (${count} entities)"
    fi
done < <(find "$dir" -maxdepth 1 -mindepth 1 -exec du -b {} \;)
