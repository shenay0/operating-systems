#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Two files as input needed"
    exit 1
fi

if ! [[ -f "${1}" && -f "${2}" ]]; then
    echo "Argument should be an existing file"
    exit 2
fi

bigger=""
count=0

for file in "${@}"; do
    lines=$(wc -l < "${file}")

    if [[ "${lines}" -gt "${count}" ]]; then
        count="${lines}"
        bigger="${file}"
    fi
done

output="${HOME}/${bigger}.songs"

cat "${bigger}" | awk -F '-' '{print $2}' | sort > "${output}"

echo -e "Result written in output file: ${output}\n"
cat "${output}"
