#!/bin/bash

# show logs with color. usage: ./taifcolor.sh <logs_file>


tail -f $1 | awk '
  /INFO/ {print "\033[32m" $0 "\033[39m"}
  /WARNING/ {print "\033[33m" $0 "\033[39m"}
  /DEBUG/ {print "\033[0m" $0 "\033[39m"}
  /ERROR/ {print "\033[0;31m" $0 "\033[39m"}
'
