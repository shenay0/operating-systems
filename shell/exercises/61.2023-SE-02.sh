#!/bin/bash


time="$1"
shift 1
comm="$*"

start=$(date "+%s%2N")
end=$((start + time*100))
count=0

while [ $(date "+%s%2N") -lt "$end" ];do
    bash -c "$comm" & pid=$!
    wait "$pid"

    count=$((count+1))
done

actualEnd=$(date "+%s%2N")
centisec=$((actualEnd-start))
seconds=$(echo "scale=2; ${centisec}/100" |  bc)
av=$(echo "scale=2; ${seconds}/${count}" | bc )

echo "Ran the command ${comm} ${count} times for ${seconds} seconds.
Average runtime: ${av} seconds"
