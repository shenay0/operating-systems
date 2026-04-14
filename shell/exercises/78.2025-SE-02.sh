#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "At least one directory"
    exit 1
fi


registry="$REGISTRY_FILE"
mkdir -p "$REPORTS_DIR"
touch "$REGISTRY_FILE"
repo="$REPORTS_DIR"

new=$(mktemp)
unchanged=$(mktemp)
changed=$(mktemp)

time=$(date '+%Y-%m-%d-%H-%M-%S')
name="${repo}/${time}.report"

touch "${name}"

for dir in "${@}"; do
    if [[ ! -d "$dir" ]]; then
        continue
    fi

    while read -r file; do
        hash=$(sha256sum "$file" | cut -d ' ' -f 1)
        if ! grep -q "${file}" "$registry"; then
            echo "          ${file}" >> "$new"
            continue
        fi
        reghash=$(grep "${file}" "$registry" | cut -d ' ' -f 1)

        if [[ "$hash" == "$reghash" ]]; then
            echo "          ${file}" >> "$unchanged"
        else
            echo "          ${file}" >> "$changed"
        fi
    done < <(find "$dir" -type f)
done

echo "new:" >> "$name"
cat "$new" >> "$name"

echo -e "\nunchanged:" >> "$name"
cat "$unchanged" >> "$name"

echo -e "\nmodified:" >> "$name"
cat "$changed" >> "$name"

> "$REGISTRY_FILE"
for dir in "${@}"; do
    find "$dir" -type f | while read -r file; do
        sha256sum "$file" >> "$REGISTRY_FILE"
    done
done

rm "$new" "$changed" "$unchanged"
