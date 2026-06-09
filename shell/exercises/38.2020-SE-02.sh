#!/bin/bash

if [ $# -ne 2 ]; then
    exit 2
fi

if [ ! -d "$2" ];then
    exit 2
fi
csv="$1"
dir="$2"

mkdir -p "$(dirname "$csv")"
echo "hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,Vlan Trunk Ports,license,SN,key" > "$csv"
while read -r line; do
    bn=$(basename "$line")

    hostname=${bn%.log}
    phy=$(grep 'Maximum Physical Interfaces' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    vlans=$(grep 'VLANs' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    insideHosts=$(grep 'Inside Hosts' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    failover=$(grep 'Failover' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    VDA=$(grep 'VPN-3DES-AES' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    peers=$(grep 'Total VPN Peers' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    vtp=$(grep 'VLAN Trunk Ports' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    licence=$(grep 'This platform has' "$line" | sed -e 's/This platform has a //' -e 's/This platform has an //' -e 's/ license.//')
    SN=$(grep 'Serial Number' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')
    key=$(grep 'Running Activation Key' "$line" | cut -d ':' -f 2 | sed 's/^ *//; s/ *$//')

    echo "${hostname},${phy},${vlans},${insideHosts},${failover},${VDA},${peers},${vtp},${licence},${SN},${key}" >> "$csv"
done < <(find "$dir" -type f -name "*.log")
