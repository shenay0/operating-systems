#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "One arg needed"
    exit 1
fi

users=$(mktemp)

ps -e -o user= | sort | uniq > "${users}"

if ! grep -q "^${1}$" "${users}"; then
    echo "User not found in the process"
    exit 2
fi

morePR=$(mktemp)
pr=$(ps -u "${1}" | tail -n +2 | wc -l)
count=$(cat "${users}" | wc -l)
times=0

while read -r user; do
    times=$(( times + $(ps -u "${user}" -o times= | tr '\n' ' ' | xargs | tr ' ' '+' | bc) ))
    lines=$(ps -u "${user}" | tail -n +2 | wc -l)
    if [[ "${pr}" -lt "${lines}" ]]; then
        echo "${user}" >> "${morePR}"
    fi
done < "${users}"

cat "${morePR}"

avg_time=$(echo "${times}/${count}" | bc)
echo "Scale b: ${avg_time}"

rm "${users}" "${morePR}"
