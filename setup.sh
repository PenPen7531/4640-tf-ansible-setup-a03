#! /usr/env/bin bash
set -o nounset

# Declare home directory
declare -r SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Go into the infrastructure directory for terraform or if dir not found produce error and exit
cd "${SCRIPT_DIR}"/infrastructure/backend_setup || exit 1


# S3 bucket and DynamoDB

# Terraform init folder
terraform init

# Run terraform application
terraform apply -auto-approve 

# Exit out or produce error message
cd ../infra || exit 1

# Infrastructure Setup

terraform init

terraform apply -auto-approve

cd ../..

# Get the EC2 instance variables
source "${SCRIPT_DIR}/script_vars.sh"

sleep 5

# Wait til AWS has the instances running
aws ec2 wait instance-running --instance-id "${web_id}"
aws ec2 wait instance-running --instance-id "${backend_id}"

# Sleep for 15 seconds to confirm instances are running
sleep 15

# Go into the ansible folder
cd "${SCRIPT_DIR}"/service || exit 1

# Run ansible command
ansible-playbook -i ./inventory/webservers.yml setup.yml 

echo "Service Running on ${web_dns}"