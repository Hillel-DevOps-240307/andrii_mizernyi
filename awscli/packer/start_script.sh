FRONT_IMG_ID=<your-front-img>
BACKEND_IMG_ID=<your-back-img>
WEB_SUBNET_ID=<your-web-subnet>
DB_SUBNET_ID=<your-db-subnet>
FRONT_SG_ID=<your-front-sg>
BACK_SG_ID=<your-back-sg>


POLICY_ARN=$(aws iam create-policy \
    --policy-name DevopsHW4Policy \
    --policy-document file://../ami_policies/add_backup_policy.json \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW4"
        }
    ]' \
    --query 'Policy.Arn' \
    --output text)


aws iam create-role \
    --role-name DevopsHW4Role \
    --assume-role-policy-document file://../ami_roles/role.json \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW4"
        }
    ]'

aws iam attach-role-policy \
    --role-name DevopsHW4Role \
    --policy-arn "$POLICY_ARN"

aws iam create-instance-profile \
    --instance-profile-name DevOpsHW4ROLE_PROFILE \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW4"
        }
    ]'

aws iam add-role-to-instance-profile \
    --instance-profile-name DevOpsHW4ROLE_PROFILE \
    --role-name DevopsHW4Role


BACK_INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$BACKEND_IMG_ID" \
    --count 1 \
    --instance-type t2.micro \
    --key-name DevOps_HW2_KEY \
    --security-group-ids "$BACK_SG_ID" \
    --subnet-id "$DB_SUBNET_ID" \
    --tag-specifications \
    'ResourceType=instance,Tags=[
        {Key=Name,Value=DevOps_HW2_BACK_SERVER},
        {Key=Project,Value=DevOps_HW2}
    ]' \
    --query 'Instances[0].InstanceId' \
    --output text)

echo BACK_INSTANCE_ID="$BACK_INSTANCE_ID"

aws ec2 wait instance-running --instance-ids "$BACK_INSTANCE_ID"

BACK_PRIVATE_IP=$(aws ec2 describe-instances \
    --instance-ids "$BACK_INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].PrivateIpAddress' \
    --output text)

echo BACK_PRIVATE_IP="$BACK_PRIVATE_IP"

MYSQL_USER="admin"
MYSQL_PASSWORD="Pa55WD"
MYSQL_DB="flask_db"
MYSQL_HOST="$BACK_PRIVATE_IP"

aws ec2 run-instances \
    --image-id "$FRONT_IMG_ID" \
    --count 1 \
    --instance-type t2.micro \
    --key-name DevOps_HW2_KEY \
    --security-group-ids "$FRONT_SG_ID" "$BACK_SG_ID" \
    --subnet-id "$WEB_SUBNET_ID" \
    --iam-instance-profile Name=DevOpsHW4ROLE_PROFILE \
    --tag-specifications \
    'ResourceType=instance,Tags=[
        {Key=Name,Value=DevOps_HW4_FRONT_SERVER},
        {Key=Project,Value=DevOps_HW4}
    ]' \
    --user-data "$(cat <<EOF
#!/bin/bash

touch backup.sh

echo '#!/bin/bash' >> backup.sh
echo 'S3_BUCKET=\$(aws ssm get-parameter \
    --name /devops-hw-4/db/S3_BUCKET \
    --region eu-central-1 \
    --query "Parameter.Value"\
    --output text)' >> backup.sh
echo 'BACKUP_FILE=db_backup_\$(date +%A).sql.gz' >> backup.sh
echo -n "mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB | gzip > " >> backup.sh
echo '\$BACKUP_FILE' >> backup.sh
echo 'aws s3 cp \$BACKUP_FILE s3://\$S3_BUCKET/' >> backup.sh

echo '07 08 * * * sudo bash /backup.sh' | crontab -

cd /home/ubuntu/flask-alb-app/

export MYSQL_USER="admin"
export MYSQL_PASSWORD="Pa55WD"
export MYSQL_DB="flask_db"
export MYSQL_HOST="$BACK_PRIVATE_IP"

gunicorn -b 0.0.0.0 appy:app

EOF
)"

