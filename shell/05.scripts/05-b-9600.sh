#!/bin/bash

if [ $# -lt 1 ];then
    exit 1
fi

if [ -z "${BACKUP_DIR}" ];then
    exit 2
fi

mkdir -p "${BACKUP_DIR}"

r=0
for arg in "${@}"; do
        timeline=$(date "+%Y-%m-%d-%H-%M-%S")

    if [ -d "$arg" ];then
        count=$(find "$arg" -maxdepth 1 -mindepth 1 | wc -l)
        bn=$(basename "$arg")
        if [ "$count" -eq 0 ]; then
            tar -czf "${BACKUP_DIR}/${bn}_${timeline}.tgz" "$arg"
            rmdir "$arg"
        elif [ "$r" -eq 1 ]; then
            tar -czf "${BACKUP_DIR}/${bn}_${timeline}.tgz" "$arg"
            rm -r "$arg"
        fi
    elif [ -f "$arg" ];then
        bn=$(basename "$arg")
        gzip -c "$arg" > "${BACKUP_DIR}/${bn}_${timeline}.gz"
        rm "$arg"
    elif [[ "$arg" == "-r" ]];then
        r=1
    else
        continue
    fi
done
