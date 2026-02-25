#!/bin/bash

touch permissions.txt permissions2.txt
ls -l
chmod 435 permissions.txt
chmod u=r,g=wx,o=rx permissions2.txt
ls -l
