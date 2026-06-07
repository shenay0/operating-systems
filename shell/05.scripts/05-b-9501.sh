#!/bin/bash
if [ $# -ne 1 ]; then
    exit 1
fi

temp=$(mktemp)
next="$1"

while IFS= read -r line; do
    if [[ "$next" == "-x" ]]; then
        echo "$line" >> "$temp"
    elif [[ "$next" == "-g" ]];then
        echo -e "\033[0;32m ${line}" >> "$temp"
        next="-b"
    elif [[ "$next" == "-b" ]];then
        echo -e "\033[0;34m ${line}" >> "$temp"
        next="-r"
    elif [[ "$next" == "-r" ]];then
        echo -e "\033[0;31m ${line}" >> "$temp"
        next="-g"
    else
        continue
    fi
done

cat "$temp"
echo -e '\033[0m'
rm "$temp"
