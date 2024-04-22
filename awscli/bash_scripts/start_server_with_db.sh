#!/bin/bash

MYSQL_USER=$(aws ssm get-parameter \
    --name "/hw-3/db/user" \
    --query "Parameter.Value"\
    --region eu-central-1 \
    --output text)

MYSQL_PASSWORD=$(aws ssm get-parameter \
    --name "/hw-3/db/password" \
    --query "Parameter.Value"\
    --with-decryption \
    --region eu-central-1 \
    --output text)

MYSQL_HOST=$(aws ssm get-parameter \
    --name "/hw-3/db/host"  \
    --query "Parameter.Value"\
    --region eu-central-1 \
    --output text)

export MYSQL_DB="flask_db"
export MYSQL_USER
export MYSQL_PASSWORD
export MYSQL_HOST

sudo apt install -y \
    python3-pip \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    git

git clone https://github.com/saaverdo/flask-alb-app -b orm

cd flask-alb-app || exit

sudo pip3 install -r requirements.txt

sudo pkill gunicorn

gunicorn -b 0.0.0.0:8000 appy:app
