#!/usr/local/bin/bash

# YAP ZFS Setup Script

######################################################################

# Text Colours

Blue='\033[0;34m'        # Text Blue
BoldBlue='\033[1;34m'    # Text Bold Blue
Cyan='\033[0;36m'        # Text Cyan
BoldCyan='\033[1;36m'    # Text Bold Cyan
Green='\033[0;32m'       # Text Green
BoldGreen='\033[1;32m'   # Text Bold Green
Red='\033[0;31m'         # Text Red
BoldRed='\033[1;31m'     # Text Bold Red
Purple='\033[0;35m'      # Text Purple
BoldPurple='\033[1;35m'  # Text Bold Purple
Yellow='\033[0;33m'      # Text Yellow
BoldYellow='\033[1;33m'  # Text Bold Yellow
CE='\033[0m'             # Colour End

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

# Function for Server Name Variable

function freebsdServerName () {
printf "\n   Please enter a server name.\n\n";
printf "   If this is the first primary server maybe name it a1.\n";
printf "   If this is the first failover server for a1 maybe name it a2.\n\n";
printf "   Choosing a naming convention is important if you plan to \n\n";
printf "   run multiple YAP servers in a primary and failover setup.\n\n";
printf "   ${BoldCyan}Table showing an example of a server naming convention:\n";
printf "     _____________________________________________________________\n";
printf "    /      FQDN        |   Primary Server   |    Failover Server   \ \n";
printf "   |-------------------|--------------------|-----------------------|\n";
printf "   |   a.example.com   |         a1         |           a2          |\n";
printf "   |-------------------|--------------------|-----------------------|\n";
printf "   |   b.example.com   |         b1         |           b2          |\n";
printf "   |-------------------|--------------------|-----------------------|\n";
printf "   |   c.example.com   |         c1         |           c2          |\n";
printf "   |-------------------|--------------------|-----------------------|\n";
printf "   |        ...        |         ...        |           ...         |\n";
printf "   |-------------------|--------------------|-----------------------|${CE}\n\n";
read -p "   Server Name: " serverName;
if [[ $serverName == "" ]]
then
  printf "\n\n   ${BoldRed}[WARNING: Server name cannot be blank]${CE}\n\n";
  freebsdServerName
fi;
}

freebsdServerName



# Function for ZFS Zpool Name Variable

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

