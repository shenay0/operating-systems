#!/bin/bash

if [ ${#} -ne 1 ]; then
    echo "One arg needed"
    exit 1
fi


user=${1}


while true; do
    if ps -e -o user= | sort | uniq | grep -qE "${user}$"; then
        echo "logged in"
        exit 0
    fi

    sleep 1

done
