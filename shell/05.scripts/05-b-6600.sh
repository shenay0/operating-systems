#!/bin/bash

if [ $# -ne 1 ]; then
    exit 1
fi

if [ ! -d "$1" ]; then
    exit 1
fi

dir="$1"


tmp1=$(mktemp)
tmp2=$(mktemp)

find "$dir" -maxdepth 1 -type f | sort > "$tmp1"

cp "$tmp1" "$tmp2"

while IFS= read -r first; do
    if [ ! -f "$first" ]; then
        continue
    fi

    while IFS= read -r second; do
        if [ ! -f "$second" ]; then
            continue
        fi

        if [ "$first" != "$second" ] && cmp -s "$first" "$second"; then
            rm "$second"
        fi

    done < "$tmp2"
done < "$tmp1"

find "$dir" -maxdepth 1 -type f
rm "$tmp1"
rm "$tmp2"
