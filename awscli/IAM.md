<details>
<summary>Example results</summary>

```

```

</details>

# HW3

## Bucket creation

```bash
aws s3 mb s3://devops-hw3-bucket
```

<details>
<summary>Example results</summary>

```
make_bucket: devops-hw3-bucket
```

</details>

```bash
aws s3 ls s3://devops-hw3-bucket
```

<details>
<summary>Example results</summary>

```
2024-04-16 11:37:47 devops-hw3-bucket
```

</details>

```bash
aws s3 cp ./bash_scripts/db_init.sh \
    s3://devops-hw3-bucket/db_init.sh
```

<details>
<summary>Example results</summary>

```
upload: bash_scripts/db_init.sh to s3://devops-hw3-bucket/db_init.sh
```

</details>


## Parameters adding

```bash
aws ssm put-parameter \
    --name VPC_ID \
    --value <your-vpc-id> \
    --type "String"
```

<details>
<summary>Example results</summary>

```
{
    "Version": 1,
    "Tier": "Standard"
}
```

</details>

```bash
VPC_ID=$(aws ssm get-parameter \
        --name VPC_ID \
        --query "Parameter.Value"\
        --output text)
echo $VPC_ID
```

<details>
<summary>Example results</summary>

```
<your-vpc-id>
```

</details>

```bash
aws ssm put-parameter \
    --name AMI_ID \
    --value <your-ami-id> \
    --type "String"
    
aws ssm put-parameter \
    --name WEB_SUBNET_ID \
    --value <your-web-subnet-id> \
    --type "String"
    
aws ssm put-parameter \
    --name DB_SUBNET_ID \
    --value <your-db-subnet-id> \
    --type "String"  
     
aws ssm put-parameter \
    --name IGW_ID \
    --value <your-igw-id> \
    --type "String" 
       
aws ssm put-parameter \
    --name GW_RT_ID \
    --value <your-gw-root-table-id> \
    --type "String"    
    
aws ssm put-parameter \
    --name LOCAL_RT_ID \
    --value <your-local-root-table-id> \
    --type "String"  
      
aws ssm put-parameter \
    --name FRONT_SG_ID \
    --value <your-front-sg-id> \
    --type "String"    
    
aws ssm put-parameter \
    --name BACK_SG_ID \
    --value <your-back-sg-id> \
    --type "String"    
    
aws ssm put-parameter \
    --name PATH_TO_DevOps_HW2_KEY \
    --value $(realpath DevOps_HW2_KEY.pem) \
    --type "String"
```

```bash
export VPC_ID=$(aws ssm get-parameter \
        --name VPC_ID \
        --query "Parameter.Value"\
        --output text)
        
export AMI_ID=$(aws ssm get-parameter \
        --name AMI_ID \
        --query "Parameter.Value"\
        --output text)
        
export WEB_SUBNET_ID=$(aws ssm get-parameter \
        --name WEB_SUBNET_ID \
        --query "Parameter.Value"\
        --output text)
        
export DB_SUBNET_ID=$(aws ssm get-parameter \
        --name DB_SUBNET_ID \
        --query "Parameter.Value"\
        --output text)
        
export IGW_ID=$(aws ssm get-parameter \
        --name IGW_ID \
        --query "Parameter.Value"\
        --output text)
        
export GW_RT_ID=$(aws ssm get-parameter \
        --name GW_RT_ID \
        --query "Parameter.Value"\
        --output text)
        
export LOCAL_RT_ID=$(aws ssm get-parameter \
        --name LOCAL_RT_ID \
        --query "Parameter.Value"\
        --output text)
        
export FRONT_SG_ID=$(aws ssm get-parameter \
        --name FRONT_SG_ID \
        --query "Parameter.Value"\
        --output text)
        
export BACK_SG_ID=$(aws ssm get-parameter \
        --name BACK_SG_ID \
        --query "Parameter.Value"\
        --output text)
        
export PATH_TO_DevOps_HW2_KEY=$(aws ssm get-parameter \
        --name PATH_TO_DevOps_HW2_KEY \
        --query "Parameter.Value"\
        --output text)
        
```

## Policies creating 

```bash
aws iam create-policy \
    --policy-name FrontServerHW3Policy \
    --policy-document file://ami_policies/front_server_policy.json \
    --description "Policy for frontend server" \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW3"
        },
        {
            "Key": "task",
            "Value": "3"
        }
    ]'
```


```bash
aws iam create-policy \
    --policy-name BackServerHW3Policy \
    --policy-document file://ami_policies/back_server_policy.json \
    --description "Policy for backend server" \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW3"
        },
        {
            "Key": "task",
            "Value": "3"
        }
    ]'
```

```bash
aws iam list-policies --scope Local
```

<details>
<summary>Example results</summary>

```
{
    "Policies": [
        {
            "PolicyName": "BackServerHW3Policy",
            "PolicyId": "<your-back-policy-id>",
            "Arn": "arn:aws:iam::<some-owner-id>:policy/BackServerHW3Policy",
            "Path": "/",
            "DefaultVersionId": "v1",
            "AttachmentCount": 0,
            "PermissionsBoundaryUsageCount": 0,
            "IsAttachable": true,
            "CreateDate": "2024-04-18T13:33:15Z",
            "UpdateDate": "2024-04-18T13:33:15Z"
        },
        {
            "PolicyName": "FrontServerHW3Policy",
            "PolicyId": "<your-front-policy-id>",
            "Arn": "arn:aws:iam::<some-owner-id>:policy/FrontServerHW3Policy",
            "Path": "/",
            "DefaultVersionId": "v1",
            "AttachmentCount": 0,
            "PermissionsBoundaryUsageCount": 0,
            "IsAttachable": true,
            "CreateDate": "2024-04-18T13:32:37Z",
            "UpdateDate": "2024-04-18T13:32:37Z"
        }
    ]
}
```

</details>


```bash
aws ssm put-parameter \
    --name BACK_POLICY_ID \
    --value <your-back-policy-id> \
    --type "String"

aws ssm put-parameter \
    --name BACK_POLICY_ARN \
    --value <your-back-policy-arn> \
    --type "String"

aws ssm put-parameter \
    --name FRONT_POLICY_ID \
    --value <your-front-policy-id> \
    --type "String"

aws ssm put-parameter \
    --name FRONT_POLICY_ARN \
    --value <your-back-policy-arn> \
    --type "String"
    
export BACK_POLICY_ID=$(aws ssm get-parameter \
    --name BACK_POLICY_ID \
    --query "Parameter.Value"\
    --output text)

export BACK_POLICY_ARN=$(aws ssm get-parameter \
    --name BACK_POLICY_ARN \
    --query "Parameter.Value"\
    --output text)
    
export FRONT_POLICY_ID=$(aws ssm get-parameter \
    --name FRONT_POLICY_ID \
    --query "Parameter.Value"\
    --output text)
    
export FRONT_POLICY_ARN=$(aws ssm get-parameter \
    --name FRONT_POLICY_ARN \
    --query "Parameter.Value"\
    --output text)
```

```bash
aws iam create-role \
    --role-name DevopsHW3FrontRole \
    --assume-role-policy-document file://ami_roles/role.json \
    --description "Role for frontend server" \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW3"
        },
        {
            "Key": "task",
            "Value": "3"
        }
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "Role": {
        "Path": "/",
        "RoleName": "DevopsHW3FrontRole",
        "RoleId": "<your-front-role-id>",
        "Arn": "",
        "CreateDate": "2024-04-19T09:21:38Z",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "support.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        },
        "Tags": [
            {
                "Key": "Project",
                "Value": "DevOps_HW3"
            },
            {
                "Key": "task",
                "Value": "3"
            }
        ]
    }
}

```

</details>

```bash
aws ssm put-parameter \
    --name FRONT_ROLE_ID \
    --value <your-front-role-id> \
    --type "String"
    
aws ssm put-parameter \
    --name FRONT_ROLE_ARN \
    --value <your-front-role-arn> \
    --type "String"

export FRONT_ROLE_ID=$(aws ssm get-parameter \
    --name FRONT_ROLE_ID \
    --query "Parameter.Value"\
    --output text)
        
export FRONT_ROLE_ARN=$(aws ssm get-parameter \
    --name FRONT_ROLE_ARN \
    --query "Parameter.Value"\
    --output text)
```


```bash
aws iam create-role \
    --role-name DevopsHW3BackRole \
    --assume-role-policy-document file://ami_roles/role.json \
    --description "Role for backend server" \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW3"
        },
        {
            "Key": "task",
            "Value": "3"
        }
    ]'
```

```bash
aws ssm put-parameter \
    --name BACK_ROLE_ID \
    --value <your-back-role-id> \
    --type "String"

aws ssm put-parameter \
    --name BACK_ROLE_ARN \
    --value <your-back-role-arn> \
    --type "String"
    
export BACK_ROLE_ID=$(aws ssm get-parameter \
    --name BACK_ROLE_ID \
    --query "Parameter.Value"\
    --output text)
        
export BACK_ROLE_ARN=$(aws ssm get-parameter \
    --name BACK_ROLE_ARN \
    --query "Parameter.Value"\
    --output text)
```

```bash
aws iam attach-role-policy \
    --role-name DevopsHW3FrontRole \
    --policy-arn $FRONT_POLICY_ARN
    
aws iam attach-role-policy \
    --role-name DevopsHW3BackRole \
    --policy-arn $BACK_POLICY_ARN
    
```


```bash
aws iam create-instance-profile \
    --instance-profile-name BACK_ROLE_PROFILE \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW3"
        },
        {
            "Key": "task",
            "Value": "3"
        }
    ]'

aws iam create-instance-profile \
    --instance-profile-name FRONT_ROLE_PROFILE \
    --tags '[
        {
            "Key": "Project",
            "Value": "DevOps_HW3"
        },
        {
            "Key": "task",
            "Value": "3"
        }
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "InstanceProfile": {
        "Path": "/",
        "InstanceProfileName": "FRONT_ROLE_PROFILE",
        "InstanceProfileId": "<your-profile_id>",
        "Arn": "your-profile-arn",
        "CreateDate": "2024-04-22T08:38:41Z",
        "Roles": [],
        "Tags": [
            {
                "Key": "Project",
                "Value": "DevOps_HW3"
            },
            {
                "Key": "task",
                "Value": "3"
            }
        ]
    }
}


```

</details>

```bash
aws ssm put-parameter \
    --name BACK_IAM_PROFILE_ID \
    --value <your-back-profile-id> \
    --type "String"

aws ssm put-parameter \
    --name BACK_IAM_PROFILE_ARN \
    --value <your-back-profile-arn> \
    --type "String"
    
export BACK_ROLE_ID=$(aws ssm get-parameter \
    --name BACK_IAM_PROFILE_ID \
    --query "Parameter.Value"\
    --output text)
        
export BACK_IAM_PROFILE_ARN=$(aws ssm get-parameter \
    --name BACK_IAM_PROFILE_ARN \
    --query "Parameter.Value"\
    --output text)

aws ssm put-parameter \
    --name FRONT_IAM_PROFILE_ID \
    --value <your-front-profile-id> \
    --type "String"

aws ssm put-parameter \
    --name FRONT_IAM_PROFILE_ARN \
    --value <your-front-profile-arn> \
    --type "String"
    
export FRONT_IAM_PROFILE_ID=$(aws ssm get-parameter \
    --name FRONT_IAM_PROFILE_ID \
    --query "Parameter.Value"\
    --output text)
        
export FRONT_IAM_PROFILE_ARN=$(aws ssm get-parameter \
    --name FRONT_IAM_PROFILE_ARN \
    --query "Parameter.Value"\
    --output text)
```

```bash
aws iam add-role-to-instance-profile \
    --instance-profile-name BACK_ROLE_PROFILE \
    --role-name DevopsHW3BackRole
    
aws iam add-role-to-instance-profile \
    --instance-profile-name FRONT_ROLE_PROFILE \
    --role-name DevopsHW3FrontRole
```

## Recreating instances

```bash
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \ 
    --instance-type t2.micro \
    --key-name DevOps_HW2_KEY \
    --security-group-ids $FRONT_SG_ID $BACK_SG_ID \
    --subnet-id $WEB_SUBNET_ID \
    --iam-instance-profile Arn=$FRONT_IAM_PROFILE_ARN \
    --tag-specifications \
    'ResourceType=instance,Tags=[
        {Key=Name,Value=DevOps_HW3_FRONT_SERVER},
        {Key=Project,Value=DevOps_HW3},
        {Key=task,Value=3}
    ]' \
    --user-data file://bash_scripts/front_init.sh
```

```bash
aws ssm put-parameter \
    --name FRONT_SERVER_ID \
    --value <your-front-server-id> \
    --type "String"

aws ssm put-parameter \
    --name FRONT_PRIVATE_IP \
    --value <your-front-server-privat-ip> \
    --type "String"
    
export FRONT_SERVER_ID=$(aws ssm get-parameter \
    --name FRONT_SERVER_ID \
    --query "Parameter.Value"\
    --output text)

export FRONT_PRIVATE_IP=$(aws ssm get-parameter \
    --name FRONT_PRIVATE_IP \
    --query "Parameter.Value"\
    --output text)
```

```bash
aws ec2 describe-instances \
    --instance-ids $FRONT_SERVER_ID \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \
    --output text
```

```bash
aws ssm put-parameter \
    --name FRONT_PUBLIC_IP \
    --value <your-front-server-public-ip> \
    --type "String"
    
export FRONT_PUBLIC_IP=$(aws ssm get-parameter \
    --name FRONT_SERVER_PUBLIC_IP \
    --query "Parameter.Value"\
    --output text)
```

```bash
aws ec2 create-image \
    --instance-id $FRONT_SERVER_ID \
    --name "DevOps_HW3_BACKEND_SERVER_AMI" \
    --tag-specifications \
    'ResourceType=image,Tags=[
        {Key=Project,Value=DevOps_HW3},
        {Key=task,Value=3}
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "ImageId": "<your-image-id>"
}

```

</details>

```bash
aws ssm put-parameter \
    --name BACKEND_IMG_ID \
    --value <your-image-id> \
    --type "String"
    
export BACKEND_IMG_ID=$(aws ssm get-parameter \
    --name BACKEND_IMG_ID \
    --query "Parameter.Value"\
    --output text)
```

```bash
echo "" >> ~/.ssh/config
echo "Host devops-hw3-web" >> ~/.ssh/config
echo "    HostName $FRONT_PUBLIC_IP" >> ~/.ssh/config
echo "    User ubuntu" >> ~/.ssh/config
echo "    IdentityFile $PATH_TO_DevOps_HW2_KEY" >> ~/.ssh/config
echo "" >> ~/.ssh/config
```

```bash
nano ~/.ssh/config
```

```bash
ssh devops-hw3-web
```

```bash
aws ec2 run-instances \
    --image-id $BACKEND_IMG_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name DevOps_HW2_KEY \
    --security-group-ids $BACK_SG_ID \
    --subnet-id $WEB_SUBNET_ID \
    --iam-instance-profile Arn=$BACK_IAM_PROFILE_ARN \
    --tag-specifications \
    'ResourceType=instance,Tags=[
        {Key=Name,Value=DevOps_HW3_BACK_SERVER},
        {Key=Project,Value=DevOps_HW2},
        {Key=task,Value=3}
    ]' \
    --user-data file://bash_scripts/back_init.sh
```

```bash
aws ssm put-parameter \
    --name BACK_SERVER_ID \
    --value <your-back-server-id> \
    --type "String"

aws ssm put-parameter \
    --name BACK_PRIVATE_IP \
    --value <your-back-server-privat-ip> \
    --type "String"
    
export BACK_SERVER_ID=$(aws ssm get-parameter \
    --name BACK_SERVER_ID \
    --query "Parameter.Value"\
    --output text)

export BACK_PRIVATE_IP=$(aws ssm get-parameter \
    --name BACK_PRIVATE_IP \
    --query "Parameter.Value"\
    --output text)
```


```bash
echo "" >> ~/.ssh/config
echo "Host devops-hw3-db" >> ~/.ssh/config
echo "    HostName $BACK_PRIVATE_IP" >> ~/.ssh/config
echo "    User ubuntu" >> ~/.ssh/config
echo "    IdentityFile $PATH_TO_DevOps_HW2_KEY" >> ~/.ssh/config
echo "    ProxyJump devops-hw3-web" >> ~/.ssh/config
echo "" >> ~/.ssh/config
```

```bash
nano ~/.ssh/config
```


```bash
sed -i "/^Host devops-hw3-web/,/    HostName .*/ s/    HostName .*/    HostName $FRONT_PUBLIC_IP/" ~/.ssh/config
```

or

```bash
sed -i "/^Host devops-hw3-db/,/    HostName .*/ s/    HostName .*/    HostName $BACK_PRIVATE_IP/" ~/.ssh/config
```

```bash
scp bash_scripts/start_server_with_db.sh devops-hw3-web:start.sh
ssh devops-hw3-web "chmod +x start.sh"
```
```bash
ssh devops-hw3-web "./start.sh"
```
