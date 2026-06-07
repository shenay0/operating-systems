#!/bin/bash

if [ $# -ne 1 ];then
    exit 1;
fi
user="$1"
pids=$(ps -u "$user" -o pid=)
count=$(echo "$pids" | grep -c .) #here even if pids are empty, echo prints a line and with grep . we grep for any cherecter and with -c we count the outc

if [ "$count" -gt 0 ]; then
    kill ${pids}
fi
