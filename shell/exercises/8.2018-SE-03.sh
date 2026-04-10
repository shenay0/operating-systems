#!bin/bash

cat /etc/passwd | sort -k 3 -t ':' -n | cut -d ':' -f 5,6 | grep 'SI
