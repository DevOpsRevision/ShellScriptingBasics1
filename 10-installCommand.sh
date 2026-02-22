#!/bin/bash
# This script demonstrates the use of conditions in bash scripting

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
   echo "ERROR:: You are NOT root user. Please run this script with root privileges."
else
    echo "You are root user. Proceeding with the installation..."
fi

dnf install mysql -y

