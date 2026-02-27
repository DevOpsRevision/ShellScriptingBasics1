#!/bin/bash
# This script demonstrates the use of functions in bash scripting

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(basename "$0" | cut -d "." -f 1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"


# Root user validation and logging the output to a log file
if [ $USERID -ne 0 ]; then
  echo -e "$R ERROR :: Please run as root user. $N"
  exit 1 # Exit with a non-zero status to indicate an error
fi

mkdir -p "$LOGS_FOLDER"

echo "Script execution started at: $(date)" &>>$LOG_FILE


if [ $USERID -ne 0 ]; then
  echo -e "$R ERROR :: You are NOT root user. Please run this script with root priviliges. $N" &>>$LOG_FILE
  exit 1 # Exit with a non-zero status to indicate an error
else
  echo "You are root user. Proceeding with the installation..." &>>$LOG_FILE
fi

VALIDATE(){
  if [ $1 -ne 0 ]; then
    echo -e "$2 installation is .... $R FAILURE $N" &>>$LOG_FILE
    exit 1 # Exit with a non-zero status to indicate an error
  else
    echo -e "$2 installation is .... $G SUCCESSFUL. $N" &>>$LOG_FILE
  fi
}

dnf list installed mysql

if [ $? -ne 0 ]; then
  echo "MySQL is not installed. Proceeding with the installation..." &>>$LOG_FILE
  dnf install mysql -y
  VALIDATE $? "MySQL"
else
   echo -e "Mysql is already installed. $Y No action needed. $N" &>>$LOG_FILE
   exit 0 # Exit with a zero status to indicate success
fi
