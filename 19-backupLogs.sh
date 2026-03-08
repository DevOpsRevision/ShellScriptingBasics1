#!/bin/bash

mkdir -p /usr/local/bin/source-dir

touch -d "15 days ago" /usr/local/bin/source-dir/cart.log
touch -d "15 days ago" /usr/local/bin/source-dir/payment.log
touch -d "15 days ago" /usr/local/bin/source-dir/shipping.log
touch -d "15 days ago" /usr/local/bin/source-dir/frontend.log
touch -d "5 days ago" /usr/local/bin/source-dir/mysql.log
touch -d "5 days ago" /usr/local/bin/source-dir/redis.log
touch -d "5 days ago" /usr/local/bin/source-dir/backup.log

mkdir -p /usr/local/bin/dest-dir

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}

LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(basename "$0" | cut -d "." -f 1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

USER_ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){
  if [ $USER_ID -ne 0 ]; then
    echo -e "$R ERROR :: You are NOT root user. Please run this script with root priviliges. $N" | tee -a $LOG_FILE
    exit 1 # Exit with a non-zero status to indicate an error
  else
    echo -e "$G INFO :: You are root user. Proceeding with the script execution. $N" | tee -a $LOG_FILE
  fi
}

VALIDATE(){
  if [ $1 -ne 0 ]; then
    echo -e "$R ERROR :: $2 .... $R FAILURE $N" | tee -a $LOG_FILE
    exit 1 # Exit with a non-zero status to indicate an error
  else
    echo -e "$G INFO :: $2 .... $G SUCCESSFUL. $N" | tee -a $LOG_FILE
  fi
}

CHECK_ROOT
mkdir -p "$LOGS_FOLDER"

USAGE(){
    echo -e "$Y USAGE :: $N sh 20-backupLogs.sh <SOURCE_DIR> <DEST_DIR> <DAYS(Optional)>"
}

#Check if correct number of arguments are provided
if [ $# -lt 2 ]; then
  USAGE
fi

#Check if destination directory exists, if not create it
if [ ! -d "$DEST_DIR" ]; then
  echo -e "$Y INFO :: Destination directory $DEST_DIR does not exist. Creating it. $N" | tee -a $LOG_FILE
fi

#Install zip utility if not present
sudo dnf install zip -y &>>$LOG_FILE
VALIDATE $? "Installing zip utility"

#Find log files older than specified days
FILES_TO_BACKUP=$(find "$SOURCE_DIR" -name "*.log" -mtime +$DAYS)
echo -e "$Y INFO :: Found the following log files older than $DAYS days in $SOURCE_DIR: $N" | tee -a $LOG_FILE
echo -e "FILES :: $FILES_TO_BACKUP \n" | tee -a $LOG_FILE

#Check if any files are found
if [ ! -z "$FILES_TO_BACKUP" ]; then
  echo -e "$G Found log files to backup.\n $N$FILES_TO_BACKUP\n" | tee -a $LOG_FILE
  ZIP_FILE="$DEST_DIR/backup-$(date +%Y%m%d).zip"
  echo "$FILES_TO_BACKUP" | zip -@ "$ZIP_FILE" &>>$LOG_FILE
  VALIDATE $? "Backup Creation Successful"

  #Validate if backup file is created successfully
  if [ -f "$ZIP_FILE" ]; then
    echo -e "$G INFO :: Backup file $ZIP_FILE created successfully. $N" | tee -a $LOG_FILE
    while IFS= read -r filepath; do 
      echo -e "$Y INFO :: Deleting file: $filepath $N" | tee -a $LOG_FILE
      rm -f "$filepath" &>>$LOG_FILE
    done <<< "$FILES_TO_BACKUP"
  else
    echo -e "$R ERROR :: Backup file $ZIP_FILE was not created. $N" | tee -a $LOG_FILE
    exit 1 # Exit with a non-zero status to indicate an error
  fi

else
  echo -e "$Y INFO :: No log files older than $DAYS days found in $SOURCE_DIR. No backup created. $N" | tee -a $LOG_FILE
fi


