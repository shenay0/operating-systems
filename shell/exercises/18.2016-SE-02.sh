#!/bin/bash
   
if [[ ${#} -ne  1 ]]; then
     echo "Exactly one argument needed!"
     exit 1
fi
  
if ! [[ ${1} =~ ^[0-9]+$ ]]; then
     echo "Argument should be a number"
     exit 3
fi
 
if [[ $(whoami) != "root" ]]; then
    echo "Only root has permission"
    exit 2
fi
 
number="${1}"
users=$(mktemp)
 
ps -e -o user= | sort | uniq > "$users"
 
while read user; do
     sum=$(ps -u "$user" -o rss= | xargs | tr ' ' '+' | bc)
     if [[ $sum -gt "$number" ]]; then
         highestPR=$(ps -u "$user" -o rss, pid | sort -k 1 -t ' ' -rn | head -n 1 | awk '{print $2}')
         #kill -TERM "$highestPR"
         sleep 2
         #kill -KILL "$highestPR"
     fi
done < <(cat "$users")


