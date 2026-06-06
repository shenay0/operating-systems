for arg in "${@}"; do
    if ! echo "${arg}" | grep -qE "^[0-9]+$"; then
        exit 3
    fi
done


if [ "${2}" -gt "${3}" ]; then
    exit 2
fi

if [ "${1}" -ge "${2}" ] && [ "${1}" -le "${3}" ];then
    exit 0
fi

exit 1
