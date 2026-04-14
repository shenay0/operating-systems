#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Two arguments needed"
    exit 1
fi

comm="$1"
file="$2"

touch "$file"

#YYYY-MM-DD-HH-wday
time=$(date '+%Y-%m-%d-%H-%A')
temp=$(mktemp)

bash -c "$comm" >> "$temp" 2>/dev/null & pid=$!
wait "$pid"
status=$?

if [[ "$status" -ne 0 ]]; then
    exit 3
fi


val=$(cat "$temp")
hour=$(date '+%H')
day=$(date '+%A')
sum=0.0
count=0
while read -r line; do
    num=$(echo "$line" | cut -d ' ' -f 2)
    sum=$(echo "${sum} + ${num}" | bc)
    count=$((count+1))

done < <(grep -w "${hour}-${day}" "$file")

echo "${time} ${val}" >> "$file"

if [[ $count -eq 0 ]]; then
    rm "$temp"
    exit 0
fi

avg=$(echo "scale=4; ${sum}/${count}" | bc)

if [[ $(echo "$val < ${avg}/2" | bc) -eq 1 || $(echo "$val > ${avg}*2" | bc) -eq 1 ]]; then
    d=$(echo "$time" | cut -d '-' -f -3)
    h=$(echo "$time" | cut -d '-' -f 4)
    echo "${d} ${h} ${val} abnormal"
    rm "$temp"
    exit 2
fi

rm "$temp"
