#!/bin/bash

if [ $# -ne 2 ] || [ ! -d "$1" ]; then
    exit 1
fi

dir="$1"
num="$2"

while read -r line; do
    du -sb "$line"
done < <(find "$dir" -maxdepth 1 -type f -size +"${num}c")
