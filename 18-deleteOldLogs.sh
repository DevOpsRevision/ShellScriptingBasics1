#!/bin/bash

mkdir -p /app-logs

touch -d "15 days ago" /app-logs/cart.log
touch -d "15 days ago" /app-logs/payment.log
touch -d "15 days ago" /app-logs/shipping.log
touch -d "15 days ago" /app-logs/frontend.log
touch -d "5 days ago" /app-logs/mysql.log
touch -d "5 days ago" /app-logs/redis.log

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(basename "$0" | cut -d "." -f 1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SOURCE_DIR=/app-logs

mkdir -p "$LOGS_FOLDER"

if [ $USERID -ne 0 ]; then
  echo -e "$R ERROR :: You are NOT root user. Please run this script with root priviliges. $N" | tee -a $LOG_FILE
  exit 1 # Exit with a non-zero status to indicate an error
else
  echo -e "$G INFO :: You are root user. Proceeding with the script execution. $N" | tee -a $LOG_FILE
fi

echo -e "Script execution started at: $(date) \n" | tee -a $LOG_FILE

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +14)

while IFS= read -r filepath; do
    echo -e "$Y INFO :: Deleting file: $filepath $N" | tee -a $LOG_FILE
    rm -f "$filepath" &>>$LOG_FILE
done <<< "$FILES_TO_DELETE"

echo -e "Script execution completed at: $(date) \n" | tee -a $LOG_FILE