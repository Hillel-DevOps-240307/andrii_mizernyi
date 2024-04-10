## Variables

- $VPC_ID
- $AMI_ID
- $WEB_SUBNET_ID
- $DB_SUBNET_ID
- $IGW_ID
- $GW_RT_ID
- $LOCAL_RT_ID
- $FRONT_SG_ID
- $BACK_SG_ID
- $FRONT_SERVER_ID
- $BACKEND_IMG_ID
- $FRONT_PUBLIC_IP
- $PATH_TO_DevOps_HW2_KEY
- $BACK_SERVER_ID
- $BACK_PRIVATE_IP

## VPC creation

```bash
aws ec2 create-vpc \
    --cidr-block 192.168.0.0/24 \
    --tag-specifications \
    'ResourceType=vpc,Tags=[
        {Key=Name,Value=DevOps_HW2_VPC},
        {Key=Project,Value=DevOps_HW2}
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "Vpc": {
        "CidrBlock": "192.168.0.0/24",
        "DhcpOptionsId": "<SOME_DHCP_OPTIONS_ID>",
        "State": "pending",
        "VpcId": "<your_vpc_id>",
        "OwnerId": "<SOME_OWNER_ID>",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [],
        "CidrBlockAssociationSet": [
            {
                "AssociationId": "<SOME_VPC_CIDR_ASSOC>",
                "CidrBlock": "192.168.0.0/24",
                "CidrBlockState": {
                    "State": "associated"
                }
            }
        ],
        "IsDefault": false
        "Tags": [
            {
                "Key": "Name",
                "Value": "DevOps_HW2_VPC"
            },
            {
                "Key": "Project_Name",
                "Value": "DevOps_HW2"
            }
        ]
    }
}
```
</details>

```bash
export VPC_ID=<your_vpc_id>
```

```bash
aws ec2 describe-route-tables \
    --filters Name=vpc-id,Values=$VPC_ID
```

<details>
<summary>Example results</summary>

```
{
    "RouteTables": [
        {
            "Associations": [
                {
                    "Main": true,
                    "RouteTableAssociationId": "<SOME_RT_ASSOCIATION_ID>",
                    "RouteTableId": "<your_rt_id>",
                    "AssociationState": {
                        "State": "associated"
                    }
                }
            ],
            "PropagatingVgws": [],
            "RouteTableId": "<your_rt_id>",
            "Routes": [
                {
                    "DestinationCidrBlock": "192.168.0.0/24",
                    "GatewayId": "local",
                    "Origin": "CreateRouteTable",
                    "State": "active"
                }
            ],
            "Tags": [],
            "VpcId": "$VPC_ID",
            "OwnerId": "<SOME_OWNER_ID>"
        }
    ]
}

```

</details>

```bash
export GW_RT_ID=<your_rt_id>
```

```bash
aws ec2 create-tags \
    --resources $GW_RT_ID \
    --tags \
        Key=Name,Value=DevOps_HW2_GW_RT \
        Key=Project,Value=DevOps_HW2
```


```bash
aws ec2 create-internet-gateway \
    --tag-specifications \
    'ResourceType=internet-gateway,Tags=[
        {Key=Name,Value=DevOps_HW2_IGW},
        {Key=Project,Value=DevOps_HW2}
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "InternetGateway": {
        "Attachments": [],
        "InternetGatewayId": "<your_igw_id>",
        "OwnerId": "<SOME_OWNER_ID>",
        "Tags": [
            {
                "Key": "Name",
                "Value": "DevOps_HW2_IGW"
            },
            {
                "Key": "Project",
                "Value": "DevOps_HW2"
            }
        ]
    }
}

```

</details>

```bash
export IGW_ID=<your_igw_id>
```

```bash
aws ec2 attach-internet-gateway \
   --internet-gateway-id $IGW_ID \
   --vpc-id $VPC_ID
```

```bash
aws ec2 create-route \
    --route-table-id $GW_RT_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $IGW_ID
```

<details>
<summary>Example results</summary>

```
{
    "Return": true
}

```

</details>


## Subnets creation

### Public subnet

```bash
aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 192.168.0.0/26 \
    --availability-zone eu-central-1a \
    --tag-specifications \
    'ResourceType=subnet,Tags=[
        {Key=Name,Value=DevOps_HW2_WEB_SUBNET},
        {Key=Project,Value=DevOps_HW2}
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1a",
        "AvailabilityZoneId": "euc1-az2",
        "AvailableIpAddressCount": 59,
        "CidrBlock": "192.168.0.0/26",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "<your_subnet_id>",
        "VpcId": "$VPC_ID",
        "OwnerId": "<SOME_OWNER_ID>",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "DevOps_HW2_WEB_SUBNET"
            },
            {
                "Key": "Project",
                "Value": "DevOps_HW2"
            }
        ],
        "SubnetArn": "<SOME_SUBNET_ARN>",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}
```

</details>

```bash
export WEB_SUBNET_ID=<your_subnet_id>
```

```bash
aws ec2 modify-subnet-attribute \
    --subnet-id $WEB_SUBNET_ID \
    --map-public-ip-on-launch
```


### Private Subnet

```bash
aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 192.168.0.64/26 \
    --availability-zone eu-central-1a \
    --tag-specifications \
    'ResourceType=subnet,Tags=[
        {Key=Name,Value=DevOps_HW2_DB_SUBNET},
        {Key=Project,Value=DevOps_HW2}
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "Subnet": {
        "AvailabilityZone": "eu-central-1a",
        "AvailabilityZoneId": "euc1-az2",
        "AvailableIpAddressCount": 59,
        "CidrBlock": "192.168.0.64/26",
        "DefaultForAz": false,
        "MapPublicIpOnLaunch": false,
        "State": "available",
        "SubnetId": "<your_subnet_id>",
        "VpcId": "$VPC_ID",
        "OwnerId": "<SOME_OWNER_ID>",
        "AssignIpv6AddressOnCreation": false,
        "Ipv6CidrBlockAssociationSet": [],
        "Tags": [
            {
                "Key": "Name",
                "Value": "DevOps_HW2_DB_SUBNET"
            },
            {
                "Key": "Project",
                "Value": "DevOps_HW2"
            }
        ],
        "SubnetArn": "<SOME_SUBNET_ARN>",
        "EnableDns64": false,
        "Ipv6Native": false,
        "PrivateDnsNameOptionsOnLaunch": {
            "HostnameType": "ip-name",
            "EnableResourceNameDnsARecord": false,
            "EnableResourceNameDnsAAAARecord": false
        }
    }
}

```

</details>

```bash
export DB_SUBNET_ID=<your_subnet_id>
```

## Local route tables creation

```bash
aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --tag-specifications \
    'ResourceType=route-table,Tags=[
        {Key=Name,Value=DevOps_HW2_LOCAL_RT},
        {Key=Project,Value=DevOps_HW2}
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "RouteTable": {
        "Associations": [],
        "PropagatingVgws": [],
        "RouteTableId": "<your_rt_id>",
        "Routes": [
            {
                "DestinationCidrBlock": "192.168.0.0/24",
                "GatewayId": "local",
                "Origin": "CreateRouteTable",
                "State": "active"
            }
        ],
        "Tags": [
            {
                "Key": "Name",
                "Value": "DevOps_HW2_LOCAL_RT"
            },
            {
                "Key": "Project",
                "Value": "DevOps_HW2"
            }
        ],
        "VpcId": "$VPC_ID",
        "OwnerId": "<SOME_OWNER_ID>"
    }
}

```

</details>

```bash
export LOCAL_RT_ID=<your_rt_id>
```

```bash
aws ec2 associate-route-table \
    --route-table-id $LOCAL_RT_ID \
    --subnet-id $DB_SUBNET_ID
```

<details>
<summary>Example results</summary>

```
{
    "AssociationId": "<some_association_id>",
    "AssociationState": {
        "State": "associated"
    }
}

```

</details>

## Security groups creation

### Front security group

```bash
aws ec2 create-security-group \
    --group-name DevOps_HW2_FRONT_SG \
    --description "Security group for front Devops HW2" \
    --tag-specifications \
    'ResourceType=security-group,Tags=[
        {Key=Name,Value=DevOps_HW2_FRONT_SG},
        {Key=Project,Value=DevOps_HW2}
    ]' \
    --vpc-id $VPC_ID
```

<details>
<summary>Example results</summary>

```
{
    "GroupId": "<your_security_group>",
    "Tags": [
        {
            "Key": "Name",
            "Value": "DevOps_HW2_FRONT_SG"
        },
        {
            "Key": "Project",
            "Value": "DevOps_HW2"
        }
    ]
}

```

</details>


```bash
export FRONT_SG_ID=<your_security_group>
```

```bash
aws ec2 authorize-security-group-ingress \
    --group-id $FRONT_SG_ID \
    --protocol tcp \
    --port 22\
    --cidr "0.0.0.0/0"
```

<details>
<summary>Example results</summary>

```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "<some_security_group_rule_id>",
            "GroupId": "$FRONT_SG_ID",
            "GroupOwnerId": "<SOME_OWNER_ID>",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 22,
            "ToPort": 22,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}

```

</details>

```bash
aws ec2 authorize-security-group-ingress \
    --group-id $FRONT_SG_ID \
    --protocol tcp \
    --port 8000\
    --cidr "0.0.0.0/0"
```
<details>
<summary>Example results</summary>

```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "<some_security_group_rule_id>",
            "GroupId": "$FRONT_SG_ID",
            "GroupOwnerId": "<SOME_OWNER_ID>",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 8000,
            "ToPort": 8000,
            "CidrIpv4": "0.0.0.0/0"
        }
    ]
}

```

</details>

### Back security group

```bash
aws ec2 create-security-group \
    --group-name DevOps_HW2_BACK_SG \
    --description "Security group for back Devops HW2" \
    --tag-specifications \
    'ResourceType=security-group,Tags=[
        {Key=Name,Value=DevOps_HW2_BACK_SG},
        {Key=Project,Value=DevOps_HW2}
    ]' \
    --vpc-id $VPC_ID
```

<details>
<summary>Example results</summary>

```
{
    "GroupId": "<your_security_group>",
    "Tags": [
        {
            "Key": "Name",
            "Value": "DevOps_HW2_BACK_SG"
        },
        {
            "Key": "Project",
            "Value": "DevOps_HW2"
        }
    ]
}

```

</details>


```bash
export BACK_SG_ID=<your_security_group>
```

```bash
aws ec2 authorize-security-group-ingress \
    --group-id $BACK_SG_ID \
    --protocol -1 \
    --port -1\
    --source-group $BACK_SG_ID
```

<details>
<summary>Example results</summary>

```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "<some_security_group_rule_id>",
            "GroupId": "$BACK_SG_ID",
            "GroupOwnerId": "<SOME_OWNER_ID>",
            "IsEgress": false,
            "IpProtocol": "-1",
            "FromPort": -1,
            "ToPort": -1,
            "ReferencedGroupInfo": {
                "GroupId": "$BACK_SG_ID",
                "UserId": "<SOME_OWNER_ID>"
            }
        }
    ]
}
```

</details>

## Instances creation

```bash
aws ssm get-parameters \
    --name "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id" \
    --output table
```

<details>
<summary>Example results</summary>

```
-------------------------------------------------------------------------------------------------------------------------------------------------
|                                                                 GetParameters                                                                 |
+-----------------------------------------------------------------------------------------------------------------------------------------------+
||                                                                 Parameters                                                                  ||
|+------------------+--------------------------------------------------------------------------------------------------------------------------+|
||  ARN             |  arn:aws:ssm:eu-central-1::parameter/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id   ||
||  DataType        |  aws:ec2:image                                                                                                           ||
||  LastModifiedDate|  1711434432.999                                                                                                          ||
||  Name            |  /aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id                                      ||
||  Type            |  String                                                                                                                  ||
||  Value           |  ami-097c96b8f62c131c5                                                                                                   ||
||  Version         |  13                                                                                                                      ||
|+------------------+--------------------------------------------------------------------------------------------------------------------------+|
```
</details>

```bash
export AMI_ID=ami-097c96b8f62c131c5
```


```bash
aws ec2 create-key-pair \
    --key-name DevOps_HW2_KEY \
    --key-type ed25519 \
    --query "KeyMaterial" \
    --output text > DevOps_HW2_KEY.pem
```

```bash
export PATH_TO_DevOps_HW2_KEY=$(realpath DevOps_HW2_KEY.pem)
```

```bash
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name DevOps_HW2_KEY \
    --security-group-ids $FRONT_SG_ID $BACK_SG_ID \
    --subnet-id $WEB_SUBNET_ID \
    --tag-specifications \
    'ResourceType=instance,Tags=[
        {Key=Name,Value=DevOps_HW2_FRONT_SERVER},
        {Key=Project,Value=DevOps_HW2}
    ]' \
    --user-data "$(cat << 'EOF'
#!/bin/bash

sudo apt update
sudo apt -y upgrade
sudo apt install -y mariadb-server
sudo mysql -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'Pa55WD'; CREATE DATABASE IF NOT EXISTS flask_db; GRANT ALL ON flask_db.* TO 'admin'@'%';"
EOF
)"
```

<details>
<summary>Example results</summary>

```
{
    "Groups": [],
    "Instances": [
        {
            "AmiLaunchIndex": 0,
            "ImageId": "$AMI_ID",
            "InstanceId": "<your-front-server-id>",
            "InstanceType": "t2.micro",
            "KeyName": "DevOps_HW2_KEY",
            "LaunchTime": "2024-04-09T15:02:58.000Z",
            "Monitoring": {
                "State": "disabled"
            },
            "Placement": {
                "AvailabilityZone": "eu-central-1a",
                "GroupName": "",
                "Tenancy": "default"
            },
            "PrivateDnsName": "<your-private-dns-name>",
            "PrivateIpAddress": "<your-private-ip>",
            "ProductCodes": [],
            "PublicDnsName": "",
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "StateTransitionReason": "",
            "SubnetId": "$WEB_SUBNET_ID",
            "VpcId": "$VPC_ID",
            "Architecture": "x86_64",
            "BlockDeviceMappings": [],
            "ClientToken": "<some-client-token>",
            "EbsOptimized": false,
            "EnaSupport": true,
            "Hypervisor": "xen",
            "NetworkInterfaces": [
                {
                    "Attachment": {
                        "AttachTime": "2024-04-09T15:02:58.000Z",
                        "AttachmentId": "<some-attachment-id>",
                        "DeleteOnTermination": true,
                        "DeviceIndex": 0,
                        "Status": "attaching",
                        "NetworkCardIndex": 0
                    },
                    "Description": "",
                    "Groups": [
                        {
                            "GroupName": "DevOps_HW2_BACK_SG",
                            "GroupId": "$BACK_SG_ID"
                        },
                        {
                            "GroupName": "DevOps_HW2_FRONT_SG",
                            "GroupId": "$FRONT_SG_ID"
                        }
                    ],
                    "Ipv6Addresses": [],
                    "MacAddress": "<some-mac-address>",
                    "NetworkInterfaceId": "<some-net-intrface-id>",
                    "OwnerId": "<SOME_OWNER_ID>",
                    "PrivateIpAddress": "<your-privat-ip>",
                    "PrivateIpAddresses": [
                        {
                            "Primary": true,
                            "PrivateIpAddress": "<your-privat-ip>"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Status": "in-use",
                    "SubnetId": "$WEB_SUBNET_ID",
                    "VpcId": "$VPC_ID",
                    "InterfaceType": "interface"
                }
            ],
            "RootDeviceName": "/dev/sda1",
            "RootDeviceType": "ebs",
            "SecurityGroups": [
                {
                    "GroupName": "DevOps_HW2_BACK_SG",
                    "GroupId": "$BACK_SG_ID"
                },
                {
                    "GroupName": "DevOps_HW2_FRONT_SG",
                    "GroupId": "$FRONT_SG_ID"
                }
            ],
            "SourceDestCheck": true,
            "StateReason": {
                "Code": "pending",
                "Message": "pending"
            },
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "DevOps_HW2_FRONT_SERVER"
                },
                {
                    "Key": "Project",
                    "Value": "DevOps_HW2"
                }
            ],
            "VirtualizationType": "hvm",
            "CpuOptions": {
                "CoreCount": 1,
                "ThreadsPerCore": 1
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "open"
            },
            "MetadataOptions": {
                "State": "pending",
                "HttpTokens": "optional",
                "HttpPutResponseHopLimit": 1,
                "HttpEndpoint": "enabled",
                "HttpProtocolIpv6": "disabled",
                "InstanceMetadataTags": "disabled"
            },
            "EnclaveOptions": {
                "Enabled": false
            },
            "BootMode": "uefi-preferred",
            "PrivateDnsNameOptions": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            }
        }
    ],
    "OwnerId": "<SOME_OWNER_ID>",
    "ReservationId": "<some-reservation-id>"
}

```

</details>

```bash
export FRONT_SERVER_ID=<your-front-server-id>
export FRONT_PRIVATE_IP=<your-private-ip>
```

```bash
aws ec2 describe-instances \
    --instance-ids $FRONT_SERVER_ID \
    --query 'Reservations[*].Instances[*].State.Name' \
    --output text
```

<details>
<summary>Example results</summary>

```
running
```

</details>

```bash
aws ec2 describe-instances \
    --instance-ids $FRONT_SERVER_ID \
    --query 'Reservations[*].Instances[*].PublicIpAddress' \
    --output text
```

<details>
<summary>Example results</summary>

```
<your-public-ip>
```

</details>

```bash
export FRONT_PUBLIC_IP=<your-public-ip>
```


```bash
aws ec2 create-image \
    --instance-id $FRONT_SERVER_ID \
    --name "DevOps_HW2_BACKEND_SERVER_AMI" \
    --tag-specifications \
    'ResourceType=image,Tags=[
        {Key=Project,Value=DevOps_HW2}
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
export BACKEND_IMG_ID=<your-image-id>
```

```bash
echo "" >> ~/.ssh/config
echo "Host devops-hw2-web" >> ~/.ssh/config
echo "    HostName $FRONT_PUBLIC_IP" >> ~/.ssh/config
echo "    User ubuntu" >> ~/.ssh/config
echo "    IdentityFile $PATH_TO_DevOps_HW2_KEY" >> ~/.ssh/config
echo "" >> ~/.ssh/config
```

```bash
nano ~/.ssh/config
```

```bash
ssh devops-hw2-web
```

```bash
aws ec2 run-instances \
    --image-id $BACKEND_IMG_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name DevOps_HW2_KEY \
    --security-group-ids $BACK_SG_ID \
    --subnet-id $DB_SUBNET_ID \
    --tag-specifications \
    'ResourceType=instance,Tags=[
        {Key=Name,Value=DevOps_HW2_BACK_SERVER},
        {Key=Project,Value=DevOps_HW2}
    ]'
```

<details>
<summary>Example results</summary>

```
{
    "Groups": [],
    "Instances": [
        {
            "AmiLaunchIndex": 0,
            "ImageId": "$BACKEND_IMG_ID",
            "InstanceId": "<your-bck-server-id>",
            "InstanceType": "t2.micro",
            "KeyName": "DevOps_HW2_KEY",
            "LaunchTime": "2024-04-09T15:02:58.000Z",
            "Monitoring": {
                "State": "disabled"
            },
            "Placement": {
                "AvailabilityZone": "eu-central-1a",
                "GroupName": "",
                "Tenancy": "default"
            },
            "PrivateDnsName": "<your-private-dns-name>",
            "PrivateIpAddress": "<your-privat-ip>",
            "ProductCodes": [],
            "PublicDnsName": "",
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "StateTransitionReason": "",
            "SubnetId": "$DB_SUBNET_ID",
            "VpcId": "$VPC_ID",
            "Architecture": "x86_64",
            "BlockDeviceMappings": [],
            "ClientToken": "<some-client-token>",
            "EbsOptimized": false,
            "EnaSupport": true,
            "Hypervisor": "xen",
            "NetworkInterfaces": [
                {
                    "Attachment": {
                        "AttachTime": "2024-04-10T07:57:02.000Z",
                        "AttachmentId": "<some-attachment-id>",
                        "DeleteOnTermination": true,
                        "DeviceIndex": 0,
                        "Status": "attaching",
                        "NetworkCardIndex": 0
                    },
                    "Description": "",
                    "Groups": [
                        {
                            "GroupName": "DevOps_HW2_BACK_SG",
                            "GroupId": "$BACK_SG_ID"
                        },
                    ],
                    "Ipv6Addresses": [],
                    "MacAddress": "<some-mac-address>",
                    "NetworkInterfaceId": "<some-net-intrface-id>",
                    "OwnerId": "<SOME_OWNER_ID>",
                    "PrivateIpAddress": "<your-privat-ip>",
                    "PrivateIpAddresses": [
                        {
                            "Primary": true,
                            "PrivateIpAddress": "<your-privat-ip>"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Status": "in-use",
                    "SubnetId": "$DB_SUBNET_ID",
                    "VpcId": "$VPC_ID",
                    "InterfaceType": "interface"
                }
            ],
            "RootDeviceName": "/dev/sda1",
            "RootDeviceType": "ebs",
            "SecurityGroups": [
                {
                    "GroupName": "DevOps_HW2_BACK_SG",
                    "GroupId": "$BACK_SG_ID"
                }
            ],
            "SourceDestCheck": true,
            "StateReason": {
                "Code": "pending",
                "Message": "pending"
            },
            "Tags": [
                {
                    "Key": "Name",
                    "Value": "DevOps_HW2_BACK_SERVER"
                },
                {
                    "Key": "Project",
                    "Value": "DevOps_HW2"
                }
            ],
            "VirtualizationType": "hvm",
            "CpuOptions": {
                "CoreCount": 1,
                "ThreadsPerCore": 1
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "open"
            },
            "MetadataOptions": {
                "State": "pending",
                "HttpTokens": "optional",
                "HttpPutResponseHopLimit": 1,
                "HttpEndpoint": "enabled",
                "HttpProtocolIpv6": "disabled",
                "InstanceMetadataTags": "disabled"
            },
            "EnclaveOptions": {
                "Enabled": false
            },
            "BootMode": "uefi-preferred",
            "PrivateDnsNameOptions": {
                "HostnameType": "ip-name",
                "EnableResourceNameDnsARecord": false,
                "EnableResourceNameDnsAAAARecord": false
            }
        }
    ],
    "OwnerId": "<SOME_OWNER_ID>",
    "ReservationId": "<some-reservation-id>"
}


```

</details>

```bash
export BACK_SERVER_ID=<your-front-server-id>
export BACK_PRIVATE_IP=<your-private-ip>
```

```bash
echo "" >> ~/.ssh/config
echo "Host devops-hw2-db" >> ~/.ssh/config
echo "    HostName $BACK_PRIVATE_IP" >> ~/.ssh/config
echo "    User ubuntu" >> ~/.ssh/config
echo "    IdentityFile $PATH_TO_DevOps_HW2_KEY" >> ~/.ssh/config
echo "    ProxyJump devops-hw2-web" >> ~/.ssh/config
echo "" >> ~/.ssh/config
```

```bash
nano ~/.ssh/config
```

```bash
ssh devops-hw2-db 'mysql --version'
```

<details>
<summary>Example results</summary>

```
mysql  Ver 15.1 Distrib 10.6.16-MariaDB, for debian-linux-gnu (x86_64) using  EditLine wrapper
```

</details>

## App installation

```bash
ssh devops-hw2-web << 'EOF'
#!/bin/bash

export MYSQL_USER="admin"
export MYSQL_PASSWORD="Pa55WD"
export MYSQL_DB="flask_db"
export MYSQL_HOST="$BACK_PRIVATE_IP"

sudo apt install -y \
    python3-pip \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    git

git clone https://github.com/saaverdo/flask-alb-app -b orm

cd flask-alb-app

sudo pip3 install -r requirements.txt

gunicorn -b 0.0.0.0:8000 appy:app
exit
EOF
```

```bash
curl -l 18.199.172.253:8000
```

<details>
<summary>Example results</summary>

```
<!DOCTYPE html>
<html>
  <head>

    <title>AppOops</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap -->
    <link href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
<link rel="shortcut icon" href="/static/favicon.ico" type="image/x-icon">
<link rel="icon" href="/static/favicon.ico" type="image/x-icon">

  </head>
  <body>
    
<div class="navbar navbar-inverse" role="navigation">
 <div class="container">
  <div class="navbar-header">
    <button type="button" class="navbar-toggle"
    data-toggle="collapse" data-target=".navbar-collapse">
      <span class="sr-only">Toggle navigation</span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
    <a class="navbar-brand" href="/">AppOops</a>
  </div>
  <div class="navbar-collapse collapse">
    <ul class="nav navbar-nav">
      <li><a href="/">Home</a></li>
          <li><a href="/display">Log</a></li>
    </ul>
  </div>
 </div>
</div>

    
<div class="container">
    
    
 <div class="page-header">
    <h1>Hello,Stranger!</h1>
    <p>You are callin from 188.163.98.100</p>
    <p>Instance ip-192-168-0-9 is serving you</p>
 </div>

<p>The local date and time is <span class="flask-moment" data-timestamp="2024-04-10T10:39:53Z" data-function="format" data-format="LLL" data-refresh="0" style="display: none">2024-04-10T10:39:53Z</span>.</p>
<p>That was <span class="flask-moment" data-timestamp="2024-04-10T10:39:53Z" data-function="fromNow" data-refresh="60000" style="display: none">2024-04-10T10:39:53Z</span></p>

</div>


    

    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment-with-locales.min.js" integrity="sha512-42PE0rd+wZ2hNXftlM78BSehIGzezNeQuzihiBCvUEB3CVxHvsShF86wBWwQORNxNINlBPuq7rG4WWhNiTVHFg==" crossorigin="anonymous"></script>

<script>
moment.locale("en");
function flask_moment_render(elem) {{
    const timestamp = moment(elem.dataset.timestamp);
    const func = elem.dataset.function;
    const format = elem.dataset.format;
    const timestamp2 = elem.dataset.timestamp2;
    const no_suffix = elem.dataset.nosuffix;
    const units = elem.dataset.units;
    let args = [];
    if (format)
        args.push(format);
    if (timestamp2)
        args.push(moment(timestamp2));
    if (no_suffix)
        args.push(no_suffix);
    if (units)
        args.push(units);
    elem.textContent = timestamp[func].apply(timestamp, args);
    elem.classList.remove('flask-moment');
    elem.style.display = "";
}}
function flask_moment_render_all() {{
    const moments = document.querySelectorAll('.flask-moment');
    moments.forEach(function(moment) {{
        flask_moment_render(moment);
        const refresh = moment.dataset.refresh;
        if (refresh && refresh > 0) {{
            (function(elem, interval) {{
                setInterval(function() {{
                    flask_moment_render(elem);
                }}, interval);
            }})(moment, refresh);
        }}
    }})
}}
document.addEventListener("DOMContentLoaded", flask_moment_render_all);
</script>


  </body>
</html>

```

</details>


## Change ssh config

```bash
export FRONT_PUBLIC_IP=<your-new-front-public-ip>
sed -i "/^Host devops-hw2-web/,/    HostName .*/ s/    HostName .*/    HostName $FRONT_PUBLIC_IP/" ~/.ssh/config
```

or

```bash
export BACK_PRIVATE_IP=<your-new-front-public-ip>
sed -i "/^Host devops-hw2-db/,/    HostName .*/ s/    HostName .*/    HostName $BACK_PRIVATE_IP/" ~/.ssh/config
```
