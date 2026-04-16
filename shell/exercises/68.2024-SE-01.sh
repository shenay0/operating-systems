#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Arguments should be at least two"
    exit 1
fi

files=$(mktemp)
commands=$(mktemp)
switches=$(mktemp)

for arg in "$@"; do
    if [[ -f "$arg" ]]; then
        echo "$arg" >> "$files"
    elif echo "$arg" | grep -q '^-R'; then
        echo "$arg" | sed 's/-R//' >> "$commands"
    else
        echo "Wrong input"
        exit 2
    fi
done

num_commands=$(cat "$commands" | wc -l)
while read -r file; do
    keys=$(pwgen -1 20 "$num_commands")
    count=1
    while read -r comm; do
        key=$(echo "$keys" | head -n "$count" | tail -n 1)
        search=$(echo "$comm" | cut -d '=' -f 1)
        switch=$(echo "$comm" | cut -d '=' -f 2)
        count=$((count+1))
        echo "${key}=${switch}" >> "$switches"
        sed -i "/^#/! s/\b${search}\b/${key}/g" "$file"
    done < "$commands"

    while read -r line; do
        search=$(echo "$line" | cut -d '=' -f 1)
        val=$(echo "$line" | cut -d '=' -f 2)

        sed -i "s/${search}/${val}/g" "$file"
    done < "$switches"

    true > "$switches"

done < "$files"


rm "$files" "$commands" "$switches"
