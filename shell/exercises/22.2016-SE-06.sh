#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "One argument needed"
    exit 1
fi

if ! [[ -f "${1}" ]]; then
    echo "Arg should be a file"
    exit 2
fi

file="${HOME}/${1}"
temp=$(mktemp)
count=1

while read -r line; do
    title=$(echo "${line}" | sed 's/^[0-9]\+[^-]*-[^[„]]*„//')
    echo "${count}. ${title}" >> "${temp}"
    ((count++))
done < "${file}"

sort "${temp}"
rm "${temp}"
