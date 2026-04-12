#!/bin/bash
  2 
  3 if [[ $# -ne 3 ]]; then
  4     echo "3 arguments needed"
  5     exit 1
  6 fi
  7 
  8 
  9 if [[ ! -f "${1}" ]]; then
 10     echo "First arg should be a file"
 11     exit 2
 12 fi
 13 
 14 
 15 if ! grep -q "${3}=" "${1}"; then
 16     echo "Argument 2 is not in the file"
 17     exit 3
 18 fi
 19 
 20 temp1=$(mktemp)
 21 temp2=$(mktemp)
 22 
 23 file="${1}"
 24 key1="${2}"
 25 key2="${3}"
 26 
 27 
 28 grep "^${key1}=" "${file}" | cut -d '=' -f 2 | tr ' ' '\n' | sort > "${temp1}"
 29 grep "^${key2}=" "${file}" | cut -d '=' -f 2 | tr ' ' '\n' | sort > "${temp2}"
 30 
 31 value=$(comm -13 "${temp1}" "${temp2}" | tr '\n' ' ' | sed 's/ $//')
 32 
 33 sed -i "s/^${key2}=.*/${key2}=${value}/" "${file}"
 34 
 35 rm "${temp1}" "${temp2}"
