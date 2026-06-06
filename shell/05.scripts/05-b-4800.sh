#!/bin/bash

if [ $# -ne 2 ]; then
    exit 2
fi

if [ ! -f "$1" ] || [ ! -d "$2" ]; then
    exit 1
fi

file="$1"
dir="$2"

while read line; do
    if cmp -s "$file" "$line"; then
        echo "$line"
    fi
done < <(find "$dir" -type f)
