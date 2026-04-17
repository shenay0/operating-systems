#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "One arg needed"
    exit 1
fi

if [[ ! -d "${1}" ]]; then
    echo "Arg should be a valid directory"
    exit 2
fi

temp=$(mktemp)
dir="${1}"
count=$(find "$dir" -type f | wc -l)
half=$(echo "$count/2" | bc)

while read -r file; do
    grep -oE '[a-z]+' "$file" | sort | uniq -c | while read -r cnt word; do
        if [[ "$cnt" -ge 3 ]]; then
            echo "$word"
        fi
    done
done < <(find "${dir}" -type f) | sort | uniq -c | while read -r num_files word; do
    if [[ "$num_files" -ge "$half" ]]; then
        echo "$word"
    fi
done > "$temp"

while read -r file; do
    grep -oE '[a-z]+' "$file"
done < <(find "$dir" -type f) | sort | uniq -c | while read -r cnt word; do
    if grep -qE "^${word}$" "$temp"; then
        echo "${cnt} ${word}"
    fi
done | sort -nr | head -n 10 | awk '{print $2}'

rm "$temp"
