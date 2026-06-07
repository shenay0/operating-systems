#!/bin/bash

if [ $# -ne 2 ]; then
    exit 1
fi

source="$1"
dest="$2"

if [ ! -d "$source" ]; then
    exit 2
fi

mkdir -p "$dest"

while read -r line; do
    filename=$(basename "$line")
    exp=""
    if [[ "$filename" == *.* ]];then
        exp=$(echo "$filename" | cut -d '.' -f2)
    else
        exp="no_exp"
    fi

    mkdir -p "${dest}/${exp}"
    mv "${line}" "${dest}/${exp}"

done < <(find "$source" -type f)
