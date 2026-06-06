if [ $# -lt 1 ]; then
    exit 1
fi

delim=' '
if [ $# -eq 2 ]; then
    delim="${2}"
fi
num="${1}"
res=""
while [ "${#num}" -gt 3 ]; do
    last="${num: -3}"
    num="${num:0:-3}"

    if [ -z "$res" ]; then
        res="$last"
    else
        res="${last}${delim}${res}"
    fi

done


if [ -z "$res" ]; then
    res="${num}"
elif [ -n "$num" ]; then
    res="${num}${delim}${res}"
else
    res="$res"
fi

echo "$res"
