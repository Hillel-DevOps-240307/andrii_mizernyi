#!/bin/bash

DB_USERNAME="admin"
GENERATED_PASSWORD=$(openssl rand -base64 12)
DB_HOST=$(hostname -I)

sudo mysql \
    -e "CREATE USER IF NOT EXISTS '$DB_USERNAME'@'%'
    IDENTIFIED BY '$GENERATED_PASSWORD';
    CREATE DATABASE IF NOT EXISTS flask_db;
    GRANT ALL ON flask_db.* TO '$DB_USERNAME'@'%';"

aws ssm put-parameter \
    --name "/hw-3/db/user" \
    --value "$DB_USERNAME" \
    --type "String" \
    --region eu-central-1 \
    --overwrite

aws ssm put-parameter \
    --name "/hw-3/db/password" \
    --value "$GENERATED_PASSWORD" \
    --type "SecureString" \
    --region eu-central-1 \
    --overwrite

aws ssm put-parameter \
    --name "/hw-3/db/host" \
    --value "$DB_HOST" \
    --type "String" \
    --region eu-central-1 \
    --overwrite
