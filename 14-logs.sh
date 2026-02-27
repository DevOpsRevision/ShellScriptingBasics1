#!/bin/bash
# This script demonstrates the use of functions in bash scripting

USERID=$(id -u)
R="\e[31m"
G="\e[32M"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
  if [ $1 -ne 0 ]; then
    echo -e "$2 installation is .... $R FAILURE $N"
    exit 1 # Exit with a non-zero status to indicate an error
  else
    echo -e "$2 installation is .... $G SUCCESSFUL. $N"
  fi
}


if [ $USERID -ne 0 ]; then
  echo -e "$R ERROR :: You are NOT root user. Please run this script with root priviliges. $N"
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
   echo -e "Mysql is already installed. $Y No action needed. $N"
   exit 0 # Exit with a zero status to indicate success
fi
