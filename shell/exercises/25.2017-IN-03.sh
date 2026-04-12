#!/bin/bash

dir=$(find / -type f -printf "%T@ %p\n" 2>/dev/null | sort -t ' ' -k1 -nr | grep -E "^.*/home/.*$" | head -n 1 | cut -d ' ' -f 2)
echo "${dir}" | cut -d '/' -f 4
