#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "One argument needed"
    exit 1
fi

if ! [[ -d "${1}" ]]; then
    echo "Argument should be a directory"
    exit 2
fi

dir="${1}"
mkdir -p "${dir}/.data"

while read -r line; do
    hashsum=$(sha256sum "${line}" | cut -d ' ' -f 1)

    if ! [[ -f "${dir}/.data/${hashsum}" ]]; then
        cp "${line}" "${dir}/.data/${hashsum}"
    fi

    if ! [[ -L "${line}" ]]; then
        rm "${line}"
        relative=$(realpath --relative-to="$(dirname "${line}")" "${dir}/.data/${hashsum}")
        ln -s "${relative}" "${line}"
    fi

done < <(find "${dir}" -type f -not -path "${dir}/.data/*")
