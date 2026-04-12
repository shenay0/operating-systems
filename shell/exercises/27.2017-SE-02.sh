#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Argumenst should be 3"
    exit 1
fi

if ! [[ -d ${1} && -d ${2} ]]; then
    echo "First two arg should be directories"
    exit 2
fi

if [[ $(whoami) != "root" ]]; then
    echo "Only root has permission for that"
    exit 3
fi

src="${HOME}/${1}"
dst="${HOME}/${2}"
str="${3}"

while read -r line; do
    base=$(basename "${line}")
    if basename "${line}" | grep -q "${str}"; then
        if [[ "${line}" == "${src}/${base}" ]]; then
            cp "${line}" "${dst}" || { echo "Copy failed for ${line}"; exit 1; }
            rm "${line}"
            continue
        fi

    newdir=$(echo "${line}" | sed "s#${src}/##" | sed "s/\/${base}//")
    mkdir -p "${dst}/${newdir}"
    echo "${newdir}"
    cp "${line}" "${dst}/${newdir}"
    rm -r "${line}"
    fi



done < <(find "${src}" -type f)
