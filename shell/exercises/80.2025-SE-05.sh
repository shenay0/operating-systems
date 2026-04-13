#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Only one arg needed"
    exit
fi

if [[ ! -d "$1" ]]; then
    echo "Arg should be a dir"
    exit 2
fi

dir="${HOME}/${1}"
group="$(stat -c "%G" "${dir}")"

if [[ $(whoami) == "root" ]]; then
    while read -r line; do

        if [[ "$(stat -c "%G" "$line")" != "$group" ]]; then
            chgrp -R "$group" "$line"
        fi

        perm=$(stat -c "%a" "$line")

        if [[ -d "$line" && "$perm" -ne "770" ]]; then
            chmod 770 "$line"
        fi

        if [[ -f "$line" && "$perm" -ne "660" ]]; then
            chmod 660 "$line"
        fi

    done < <(find "$dir")

elif id -nG | grep -qw "$group"; then
    umask 007

else
    echo "User needs to be a member of the group"
    exit 3
fi
