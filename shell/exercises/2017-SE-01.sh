#!/bin/bash

ls -l | tail -n +2 | awk '{print $2, $NF}' | sort -nr | head -5 | awk '{print $2}'
