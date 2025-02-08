#!/usr/local/bin/bash

# YAP ZFS Setup Script

######################################################################

# Text Colours

Green='\033[0;32m'     # Text Green
BoldGreen='\033[1;32m' # Text Bold Green
Red='\033[0;31m'       # Text Red
BoldRed='\033[1;31m'   # Text Bold Red
CE='\033[0m'           # Colour End

######################################################################

# Check if user is root otherwise exit

if [ "$EUID" -ne 0 ]
then
  printf "\n   ${BoldRed}[WARNING: Must be root user to run script]${CE}   \n\n";
  exit;
fi;

cd /root;

######################################################################

# Check YAP repository has been downloaded from GitHub and in the /root directory

if [ ! -d "/root/YAP" ]
then
  printf "\n   ${BoldRed}[WARNING: YAP repository does not exist in /root.\n";
  printf "             Please run: \"cd /root; git clone https://github.com/Ellwould/YAP\"\n";
  printf "             and run zfs-setup.sh script again]${CE}\n\n";
  exit;
fi;

######################################################################

# Values for variables

function freebsdServerName () {
printf "\n   Please enter a server name. If this is\n\n";
printf "   the first primary server maybe name it a1. If this is the first\n";
printf "   failover server for a1 maybe name it a2.\n\n";
printf "   Choosing a naming convention is important if you plan to \n\n";
printf "   run multiple YAP servers in a primary and failover setup.\n\n";
printf "      ______________________________________________________________\n";
printf "    / IPv4 Address | IPv6 Address  | Primary Server | Failover Server \\n";
printf "   |---------------|---------------|----------------|------------------|\n";
printf "   |   192.0.2.1   |  2001:db8::1  |       a1       |        a2        |\n";
printf "   |---------------|---------------|----------------|------------------|\n";
printf "   |   192.0.2.2   |  2001:db8::2  |       b1       |        b2        |\n";
printf "   |---------------|---------------|----------------|------------------|\n";
printf "   |   192.0.2.3   |  2001:db8::3  |       c1       |        c2        |\n";
printf "   |---------------|---------------|----------------|------------------|\n";
printf "   |      ...      |      ...      |       ...      |        ...       |\n";
printf "   |---------------|---------------|----------------|------------------|\n";
fi;
}

function zfsZpoolName () {

printf "\n   Please enter ZFS zpool name (default is zpool) \n\n";
read -p "   ZFS zpool name: " zpoolName;
if [[ $zpoolName == "" ]]
then
  printf "\n\n   ${BoldRed}[WARNING: ZFS zpool name cannot be blank]${CE}\n\n";
  zfsZpoolName;
fi;
}

zfsZpoolName

######################################################################

# Delete any that are not needed (47 in total)

