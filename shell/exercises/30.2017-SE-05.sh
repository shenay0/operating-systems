#!/bin/bash

if [ $# -ne 2 ]; then
    exit 1
fi

if [ ! -d "$1" ];then
    exit 1
fi


if [ -z "$2" ];then
    exit 1
fi

dir="$1"
str="$2"

temp=$(mktemp)

find "$dir" -maxdepth 1 -type f -printf "%f\n"| grep -E "^vmlinuz-[0-9]+\.[0-9]+\.[0-9]+-${str}$" >> "$temp"

cat "$temp" | sort -t '-' -k2 -nr | head -n 1
rm "$temp"
