#!/bin/bash

find -type d -exec chmod 755 {} \;
ls -l | grep '^d'

