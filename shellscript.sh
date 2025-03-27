#!/bin/bash

# Configuration
SOURCE_DIR="/path/to/source"   # Directory to back up
BACKUP_DIR="/path/to/backup"   # Local backup storage path
REMOTE_SERVER="user@remote-server:/remote/backup/location"
LOG_FILE="/var/log/backup.log"

# Timestamp for backup file
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"

# Create backup archive
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR" 2>>$LOG_FILE

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "[INFO] Backup successful: $ARCHIVE_NAME" | tee -a $LOG_FILE
    
    # Transfer to remote server
    scp "$BACKUP_DIR/$ARCHIVE_NAME" "$REMOTE_SERVER" 2>>$LOG_FILE
    if [ $? -eq 0 ]; then
        echo "[INFO] Backup uploaded successfully to remote server." | tee -a $LOG_FILE
    else
        echo "[ERROR] Failed to upload backup to remote server." | tee -a $LOG_FILE
    fi
else
    echo "[ERROR] Backup failed." | tee -a $LOG_FILE
fi

# Cronjob suggestion for automation
# Add this line to your crontab for daily backups:
# 0 2 * * * /path/to/backup_solution.sh
