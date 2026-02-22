#!/bin/bash
# This script demonstrates the use of conditions in bash scripting

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
   echo "ERROR:: You are NOT root user. Please run this script with root privileges."
   exit 1 # Exit with a non-zero status to indicate an error
else
    echo "You are root user. Proceeding with the installation..."
fi

dnf install mysql -y

if [ $? -eq 0 ]; then
   echo "MySQL installation is .... SUCCESSFUL."
else
   echo "MySQL installation is .... FAILURE"