#!/bin/bash

grep ",I" /etc/passwd | grep "а," /etc/passwd | cut -d ':' -f 1 | cut -c 3-4 | sort | uniq -c | sort -nr |head -1

