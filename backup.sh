#!/bin/bash

# ==== LOAD ENVIRONMENT VARIABLES ====
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# ==== CREATE BACKUP DIRECTORY IF NOT EXISTS ====
mkdir -p "$BACKUP_PATH"

# ==== TIMESTAMP ====
DATE=$(date +%F-%H-%M)

# ==== FILE NAMES ====
BACKUP_FILE="$BACKUP_PATH/${DB_NAME}_backup_$DATE.sql"
ZIP_FILE="${BACKUP_FILE}.gz"

# ==== MYSQL DUMP ====
echo "Creating MySQL dump..."
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_FILE"

# ==== COMPRESS ====
echo "Compressing backup..."
gzip "$BACKUP_FILE"

# ==== UPLOAD TO S3 ====
echo "Uploading $ZIP_FILE to S3..."
aws s3 cp "$ZIP_FILE" s3://"$S3_BUCKET"/

# ==== DELETE OLD FILES FROM S3 (OLDER THAN 2 DAYS) ====
echo "Checking for old backups in S3 to delete..."
aws s3 ls s3://"$S3_BUCKET"/ | while read -r line; do
    FILE_DATE=$(echo $line | awk '{print $1" "$2}')
    FILE_NAME=$(echo $line | awk '{print $4}')
    if [[ $FILE_NAME == *"$DB_NAME"* ]]; then
        FILE_TIME=$(date -d "$FILE_DATE" +%s)
        NOW=$(date +%s)
        AGE=$(( (NOW - FILE_TIME) / 86400 ))
        if [ $AGE -gt 2 ]; then
            echo "Deleting old backup: $FILE_NAME"
            aws s3 rm s3://"$S3_BUCKET"/"$FILE_NAME"
        fi
    fi
done

echo "✅ Backup completed successfully!"
