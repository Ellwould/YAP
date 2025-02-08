#!/usr/local/bin/bash

# YAP ZFS Setup Script

######################################################################

# Check if user is root otherwise exit

if [ "$EUID" -ne 0 ]
then
  printf "\nPlease run as root\n\n";
  exit;
fi;

cd /root;

######################################################################

# Check YAP repository has been downloaded from GitHub and in the /root directory

if [ ! -d "/root/YAP" ]
then
  printf "\nYAP repository does not exist in /root.\n";
  printf "Please run: \"cd /root; git clone https://github.com/Ellwould/YAP\"\n";
  printf "and run zfs-setup.sh script again\n\n";
  exit;
fi;

######################################################################

# Values for variables

printf "\n   Please enter ZFS zpool name (default is zpool) \n\n";
read -p "   ZFS zpool name: " zfsZpoolName;

######################################################################

# Delete any that are not needed (47 in total)

