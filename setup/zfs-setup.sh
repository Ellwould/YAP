#!/usr/local/bin/bash

######################################################################

# Check if user is root otherwise exit

if [ "$EUID" -ne 0 ]
then
  printf "\nPlease run as root\n\n";
  exit;
fi;

cd /root;

######################################################################

# Delete any that are not needed (47 in total)

