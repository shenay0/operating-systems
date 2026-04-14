#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "At least one argument- action"
    exit 1
fi

dir="$SVC_DIR"
action="$1"
#start
if [[ ${action} == "start" && ! -z "${2}" ]]; then
    file=$(find "$dir" -type f -exec grep -l "name:.*${2}" {} \;)
    comm=$(grep "comm: " "$file" | cut -d ' ' -f 2-)
    pidfile=$(grep "pidfile:" "$file" | cut -d ' ' -f 2-)
    if [[ -f "$pidfile" ]]; then
        temppid=$(cat "$pidfile")
        if kill -0 "$temppid" 2>/dev/null; then
            echo "The process is already started"
            exit 0
        fi
    fi
    outfile=$(grep "outfile: " "$file" | cut -d ' ' -f 2-)

    bash -c "$comm" >> "$outfile" 2>&1 & pid=$!
    mkdir -p "$(dirname "$pidfile")"
    echo "$pid" > "$pidfile"

elif [[ "$action" == "stop" && ! -z "$2" ]]; then
    file=$(find "$dir" -type f -exec grep -l "name:.*${2}" {} \;)
    pidfile=$(grep "pidfile:" "$file" | cut -d ' ' -f 2-)
    pid=$(cat "$pidfile")

    kill -SIGTERM "$pid"

elif [[ "$action" == "running" ]]; then
    temp=$(mktemp)
    while read -r file; do
        name=$(grep "name: " "$file" | cut -d ' ' -f 2-)
        pidfile=$(grep "pidfile: " "$file" | cut -d ' ' -f 2-)

        if [[ -f "$pidfile" ]]; then
            pid=$(cat "$pidfile")
            if kill -0 "$pid" 2>/dev/null; then
                echo "$name" >> "$temp"
            fi
        fi

    done < <(find "$dir" -type f)

    sort "$temp"
    rm "$temp"

elif [[ "$action" == "cleanup" ]]; then
    while read -r file; do
        pidfile=$(grep "pidfile: " "$file" | cut -d ' ' -f 2-)

        if [[ -f "$pidfile" ]]; then
            if ! kill -0 "$(cat "$pidfile")" 2>/dev/null; then
                rm "$pidfile"
            fi
        fi
    done < <(find "$dir" -type f)
fi
