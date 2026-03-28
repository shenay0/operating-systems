#!/bin/bash

find -type f -links +1 -printf "%T@ %i\n" | sort -nr | head -1 | awk '{print $2}'
