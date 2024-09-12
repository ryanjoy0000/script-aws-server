#!/bin/bash

# Values below are for the specific EC2 instance (from the AWS Console)
REGION="us-east-1"
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0182f373e66f89c85" # Image id

# Custom
r=$((1 + $RANDOM % 100))
SECURITY_GROUP_NAME="Security Group ${r}"
SECURITY_DESC="To automate the creation of EC2 instance"

# Function to handle errors
err() {
  echo "$1" 1>&2
  exit 1
}

# create key pair, store it & change to read only mode
echo "creating key pair.."
KEY_NAME="secret_${r}"
rm -rf secret_* # remove any old keys
echo "created key - ${KEY_NAME}"
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text >${KEY_NAME}.pem || err "error while creating key pair"
chmod 400 ${KEY_NAME}.pem || err "error while setting read only mode for the key file"

# create security group and store id
echo "creating security group..."
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "${SECURITY_GROUP_NAME}" --description "${SECURITY_DESC}" --query 'GroupId' --output text --region ${REGION}) || err "error while creating security group"

# add inbound (ingress) firewall rules to the security group.
# allow SSH and HTTP access
echo "setting SSH and HTTP access to the security group..."
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --no-paginate --no-cli-pager|| err "error while setting SSH access to instance"
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --no-paginate --no-cli-pager|| err "error while setting HTTP access to instance"

# Launch EC2 instance
echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SECURITY_GROUP_ID --query 'Instances[0].InstanceId' --output text --region $REGION)
echo "Instance id: ${INSTANCE_ID}"

# Wait for the instance to be in the "running" state
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text --region $REGION)
echo "Instance is up! Public IP: $PUBLIC_IP" 
echo "Waiting for instance to be ready for SSH..."
sleep 15  # Wait for few seconds

# Install Docker, Python, and Nginx on the instance
echo "Connecting to the instance and installing software..."
# SSH session - avoid manual confirmation for the first-time SSH connection.
ssh -o "StrictHostKeyChecking=no" -i ${KEY_NAME}.pem ec2-user@$PUBLIC_IP << 'EOF'
  set -e # Exit on any command failure
  # Function to handle errors within the SSH session
  err() {
    echo "$1" 1>&2
    exit 1
  }
  sudo yum update -y || err "error while updating yum pkgs"

  # Install Docker
  echo "installing docker ..."
  sudo yum install docker -y || err "error while installing docker"
  sudo service docker start
  sudo usermod -a -G docker ec2-user

  # Install Python 3
  echo "installing python3 "
  sudo yum install python3 -y|| err "error while installing python"

  # Install Nginx
  echo "installing nginx"
  sudo yum install nginx -y || err "error while installing nginx"
  sudo systemctl start nginx
  sudo systemctl enable nginx

  echo "Docker, Python, and Nginx have been installed successfully!"
  echo "script execution complete!"
EOF
