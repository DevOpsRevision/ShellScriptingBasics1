#!/bin/bash
# This script demonstrates the use of functions in bash scripting

VALIDATE(){
  if [ $1 -ne 0 ]; then
    echo "$2 installation is .... FAILURE"
    exit 1 # Exit with a non-zero status to indicate an error
  else
    echo "$2 installation is .... SUCCESSFUL."
  fi
}

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
  echo "ERROR:: You are NOT root user. Please run this script with root priviliges."
  exit 1 # Exit with a non-zero status to indicate an error
else
  echo "You are root user. Proceeding with the installation..."
fi

dnf list installed mysql

if [ $? -ne 0 ]; then
  echo "MySQL is not installed. Proceeding with the installation..."
  dnf install mysql -y
  VALIDATE $? "MySQL"
else
   echo "Mysql is already installed. No action needed."
   exit 0 # Exit with a zero status to indicate success
fi
