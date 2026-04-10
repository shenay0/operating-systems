#!/bin/bash

find /var/log/my_logs -type f | grep -E ".*-0-9a-zA-z_]+_[0-9]*\.log" | xargs grep -o "error"
