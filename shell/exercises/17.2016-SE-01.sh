#!/bin/bash
  
 dir="$1"
 
 if [ ${#} -ne 1 ]; then
     echo "Only one agrument"
     exit 1
 fi 
  
 if ! [ -d "${dir}" ]; then
      echo "Not directory"
      exit 2
 fi
  
 while read -r line; do
     if ! [ -e "${line}" ]; then
         echo "${line}"
     fi
 done < <(find "$dir" -type l 2>/dev/null)
 
