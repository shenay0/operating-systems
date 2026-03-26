#!/bin/bash

#a)
find . -type f -size 0 -delete

#b)
find -type f -printf "%s %p\n" | sort -n -r | awk '{print $2}' | xargs rm -f

