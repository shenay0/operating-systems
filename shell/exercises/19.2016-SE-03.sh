#!/bin/bash

if [[ "$(whoami)" != "root" ]]; then
    echo "Only root has permission"
    exit 1
fi

file="/etc/passwd"

while read -r line; do
    username=$(echo "$line" | cut -d ':' -f 1)
    dir=$(echo "$line" | cut -d ':' -f 6)
   
    if ! [[ -e "$dir" ]]; then
        echo "${username} home directory doesnt exist"
        continue
    fi
   
    permission=$(stat -c "%A" "$dir" | cut -c 3)
   
    if [[ "$permission" != "w" ]]; then
        echo "${username} doesnt have permission to write"
    fi
done < <(cat $file)
