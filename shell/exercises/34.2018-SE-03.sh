#!/bin/bash

if [ $# -ne 2 ];then
    exit 1
fi

if [ ! -f "$1" ]; then
    exit 1
fi

temp=$(mktemp)
a="$1"
b="$2"

while IFS= read -r line; do
    id=$(echo "$line" | cut -d ',' -f 1 )
    rest=$(echo "$line" | cut -d ',' -f 2-)

    if cat "$temp" | grep -qE "^[0-9]+,${rest}$"; then
        id2=$(cat "$temp" | grep -E "^[0-9]+,${rest}$" | cut -d ',' -f 1)

        if [ "$id" -lt "$id2" ];then
            sed -i "s/${id2},${rest}/${id},${rest}/" "$temp"
        else
            continue
        fi
    else
        echo "$line" >> "$temp"
    fi

done < "$a"

cat "$temp" > "$b"
rm "$temp"
