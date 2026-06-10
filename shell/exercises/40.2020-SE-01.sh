#!/bin/bash

if [ $# -ne 2 ];then
    exit 2
fi

if [ ! -d "$1" ] || [ ! -d "$2" ];then
    exit 3
fi

packet="$2"
repo="$1"

name=$(basename "$packet")
vers=$(cat "$packet/version")
tar -C "${packet}/tree" -caf "${name}.tar" . #vliza v direktoriqta i arhivira sudurjanieto, a ne samata direktoriq tree
xz -z "${name}.tar"
arch="${name}.tar.xz"

sha=$(sha256sum "$arch" | awk '{print $1}')

if cat "${repo}/db" | grep "${name}-${vers} ";then
    remove=$(grep "${name}-${vers} " "${repo}/db" | cut -d ' ' -f 2)
    rm "${repo}/packages/${remove}.tar.xz"

    mv "${arch}" "${repo}/packages/${sha}.tar.xz"
    sed -i "s/${remove}/${sha}/" "${repo}/db"
else
    mv "$arch" "$repo/packages/${sha}.tar.xz"
    echo "${name}-${vers} ${sha}" >> "${repo}/db"
    sort -o "$repo/db" "${repo}/db"
fi
