#!/bin/bash

if [[ $1 != "java" ]];then
    exit 2
fi

shift 1

metJar=0
metFile=0

options=$(mktemp)
arguments=$(mktemp)
filename=""

for arg in "${@}"; do
    if [[ "$arg" == "-jar" ]];then
            metJar=1
    elif [ "$metJar" -eq 1 ] &&  [[ "$arg" == -* ]] && [ "$metFile" -eq 0 ];then
        echo "$arg" >> "$options"
    elif [ "$metJar" -eq 1 ] && [ "$metFile" -eq 0 ];then
        filename="$arg"
        metFile=1
    elif [ "$metFile" -eq 1 ];then
        echo "$arg" >> "$arguments"                
    else
        echo "Wrong syntaxis"
        exit 2
    fi
done

java $(cat "$options" | tr '\n' ' ') -jar "$filename" $(cat "$arguments" | tr '\n' ' ')
