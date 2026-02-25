#!/bin/bash

find . -cmin -60

# -60 shows the files changed less than an hour ago
# 60 shows the files changed exactly an hour ago
# +60 shows the files changed more than an hour ago
