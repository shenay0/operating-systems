#!/bin/bash

if [ $# -ne 1 ] || [ ! -f "$1" ];then
    exit 3
fi
file="$1"

virt="/proc/acpi/wakeup"
while read -r line; do
    name=$(echo "$line" | awk '{print $1}')
   
    if ! [[ "$name" =~ ^[A-Z]+$ ]];then
        continue
    fi
   
    state=$(echo "$line" | awk '{print $2}')
    if [[ "$state" != "disabled" ]] && [[ "$state" != "enabled" ]];then
        continue
    fi
   
    if ! grep -qE "${name}" "$virt"; then   
        echo "No device named ${name}"
        continue
    fi
   
    deviceStatus=$(grep "${name}" "$virt" | awk '{print $3}' | tr '*' ' ')
   
    if [[ "$state" == "${deviceStatus}" ]];then
        continue
    else
        echo "$name" > "$virt"
    fi
   
done < "$file"
