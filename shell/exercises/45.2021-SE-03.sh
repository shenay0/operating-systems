  1 #!/bin/bash
  2 
  3 if [ $# -lt 1 ];then
  4     exit 1
  5 fi
  6 
  7 change(){
  8     file="$1"
  9     serial="$2"
 10     today=$(date "+%Y%m%d")
 11 
 12     if [ "$today" -eq "${serial:0:-2}" ]; then
 13         count="${serial: -2}"
 14 
 15         if [ "$count" -eq 99 ];then
 16             echo "Cannot change SOA serial num of ${file}"
 17             exit 2
 18         fi
 19 
 20         new=$((count+1))
 21         cnt=$(echo -n "$new" |  wc -m)
 22         if [ "$cnt" -eq 2 ]; then
 23             sed -i "s/${serial}/${today}${new}/" "$file"
 24         else
 25             sed -i "s/${serial}/${today}0${new}/" "$file"
 26         fi
 27     else
 28         sed -i "s/${serial}/${today}00/" "$file"
 29     fi
 30 
 31 }
 32 
 33 
 34 for arg in "${@}"; do
 35     if [ ! -f "$arg" ];then
 36         exit 2
 37     fi
 38 
 39     type=$(cat "$arg" | head -n 1 | cut -d ' ' -f 4)
 40 
 41     if [[ "$type" == "SOA" ]];then
 42         symbol=$(cat "$arg" | head -n 1 | cut -d ' ' -f 7)
 43         if [[ "$symbol" == "(" ]];then
 44             serial=$(grep "serial" "$arg" | cut -d ';' -f 1 | sed "s/^ *//; s/ *$//")
 45         else
 46             serial=${symbol}
 47         fi
 48 
 49         change "$arg" "$serial"
 50     fi
 51 done
~

