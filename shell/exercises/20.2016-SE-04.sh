#!/bin/bash


if [[ $# -ne 2 ]]; then
    echo "2 arguments needed"
    exit 1
fi

if ! [[ "${1}" =~ ^[0-9]+$ && "${2}" =~ ^[0-9]+$ ]]; then
    echo "Arguments need to be a number"
    exit 2
fi

mydir="${HOME}/task20"
a="${HOME}/a"
b="${HOME}/b"
c="${HOME}/c"
while read -r file; do
    count=$(cat "$file" | wc -l)
    if [[ "$count" -lt "${1}" ]]; then
        mv "$file" "$a"
    elif [[ "$count" -gt "${1}" && "$count" -lt "${2}" ]]; then
        mv "$file" "$b"
    else
        mv "$file" "$c"
    fi
done < <(find "$mydir" -type f)
