#!/bin/bash

if [ $# -lt 1 ];then
    exit 1
fi

if [ -z "${log_file}" ]; then
    exit 2
fi

mkdir -p "$(dirname "${log_file}")"

r=0

for arg in "${@}"; do
    timeline=$(date )
    if [ -f "$arg" ];then
        rm "$arg"
        echo "${arg} deleted: $(date "+%Y-%m-%d %H:%M:%S")" >> "${log_file}"
    elif [ -d "$arg" ];then
        count=$(find "${arg}" -maxdepth 1 -mindepth 1 | wc -l)
        if [ "$count" == 0 ];then
            rmdir "$arg"
            echo "${arg} deleted: $(date "+%Y-%m-%d %H:%M:%S")" >> "${log_file}"
        else
            if [ "$r" -eq 1 ];then
                rm -r "$arg"
                echo "${arg} deleted: $(date "+%Y-%m-%d %H:%M:%S")" >> "${log_file}"
            fi
        fi
    else
        if [[ "$arg" == "-r" ]];then
            r=1
        else
            continue
        fi
    fi
done
