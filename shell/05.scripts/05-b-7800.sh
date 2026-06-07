#!/bin/bash

count=0

for dir in $(echo "${PATH}" | tr ':' ' '); do
    if [ -d "$dir" ]; then
        c=$(find -maxdepth 1 -type f -executable | wc -l)
        count=$((count+c))
    fi
done

echo "$count"
