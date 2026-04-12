#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Needs at least one arg"
    exit 2
fi

if [[ ! -d "${1}" ]]; then
    echo "First arg should be a directory"
    exit 1
fi

file="${1}"

if [[ $# -eq 2 ]];then
    number="${2}"
    while read -r line; do
        inode=$(echo "${line}" | cut -d ' ' -f 1)
        path=$(echo "${line}" | cut -d ' ' -f 2)
        hardlinks=$(find "${file}" -inum "${inode}" -printf "%n\n" | head -n 1)

        if [[ "${hardlinks}" -ge "${number}" ]]; then
            echo -e "${path}\n"
        fi
    done < <(find "${file}" -type f -printf "%i %p \n")

else
    while read -r line; do
        if [[ ! -e "${line}" ]]; then
            echo -e "Non existent symlink: ${line}\n"
        fi
    done < <(find "${file}" -type l)

fi
