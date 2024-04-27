#!/bin/bash

S3_BUCKET=$(aws ssm get-parameter \
    --name /devops-hw-4/db/S3_BUCKET \
    --query "Parameter.Value"\
    --output text)

BACKUP_FILE="db_backup_$(date +%A).sql.gz"

mysqldump -h 192.168.0.88 -u admin -pPa55WD flask_db | gzip > "$BACKUP_FILE"

aws s3 cp "$BACKUP_FILE" s3://"$S3_BUCKET"/
