#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "2 arguments needed"
    exit 1
fi


if [[ ! -f "$1" || ! -f "$2" ]]; then
    echo "Arguments should be a file"
    exit 2
fi


file="${1}"
input="${2}"
while read -r line; do
    count=$(echo "$line" | wc -w)
    language=$(echo "$line" | cut -d ' ' -f 1)
    actions=$(echo "$line" | cut -d ' ' -f 2-$(("$count"-1)))
    commands=""
    if ! echo "$actions" |  grep -qw "listener"; then
        commands="${commands} -no-listener"
    fi

    if echo "$actions" | grep -qw "visitor"; then
        commands="${commands} -visitor"
    fi

    name=$(basename "$input" | sed 's/\..*//')
    exitdir=$(echo "$line" | cut -d ' ' -f "$count" | sed "s/'//g")

    antlr4 -Dlanguage="$language" $commands -o "${exitdir}/${name}" "${input}"


done < "${file}"
