#!/bin/bash

a="$1"
b="$2"

num=$(((RANDOM%b) + a))
c=$((a+b-1))
echo "Guess a number between ${a} and ${c}"

while true; do
    read x;
    if [ "$x" -gt "$num" ]; then
        echo "less..."
    elif [ "$x" -lt "${num}" ];then
        echo "greater..."
    elif [ "$x" -eq "$num" ]; then
        echo "YAYYY CONGRATS"
        exit 0
    else
        echo "A NUMBER!!!"
    fi
done
