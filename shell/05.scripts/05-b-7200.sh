#!/bin/bash

if [ $# -lt 1 ]; then
    exit 1
fi

for arg in "${@}"; do
    if [ -f "$arg" ];then
        if [ -r "$arg" ];then
            echo "${arg}    -   readable file"
        else
            echo "${arg}    -   not readale file"
        fi
    elif [ -d "$arg" ];then
        count=$(find "$arg" -maxdepth 1 -mindepth 1 -type f | wc -l)

        while read -r line; do
            basename "$line"
        done < <(find "$arg" -maxdepth 1 -mindepth 1 -type f -size "-${count}c")
    fi
done
