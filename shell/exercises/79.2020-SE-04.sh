#!/bin/bash


if [[ $# -ne 2 ]]; then
    echo "Arguments should be 2"
    exit 1
fi

if [[ ! -d "$1" && ! -d "$2" ]]; then
    echo "Arguments should be directories"
    exit 2
fi



bomba="$1"
bomba2="$2"

find "$bomba" -mindepth 1 -type d | sed "s#${bomba}#${bomba2}#" | xargs mkdir -p

for file in $(find "$bomba" -type f | grep -E ".*bcf" ); do
    uniq_keys=$(cat "$file" | sort | cut -d '=' -f 1 | uniq)
    name=$( echo "$file" | sed "s#${bomba}#${bomba2}#" | sed 's/.*/&2/' )
    touch "$name"

    for key in $uniq_keys; do
        count=$(cat "$file" | grep "^${key}=" | wc -l)

        if [[ "$count" -eq 1 ]]; then
            value=$(cat "$file" | grep "^${key}=" | cut -d '=' -f 2-)
            echo "${key}: ${value}" >> "${name}"
        else
            echo "${key}: " >> "$name"
            while read -r line; do
                echo "        -${line}" >> "$name"
            done < <(grep "^${key}=" "$file" | cut -d '=' -f 2-)
        fi
    done
done
