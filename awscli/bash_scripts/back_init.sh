#!/bin/bash

aws s3 cp s3://devops-hw3-bucket/db_init.sh .

chmod +x ./db_init.sh

./db_init.sh
