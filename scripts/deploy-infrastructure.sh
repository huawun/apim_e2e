#!/bin/bash
set -e

echo "Deploying Azure infrastructure..."

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "Please create .env file from .env.example"
    exit 1
fi

# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan \
    -var="resource_group_name=$RESOURCE_GROUP_NAME" \
    -var="location=$LOCATION" \
    -var="app_name=$APP_NAME" \
    -var="container_registry_name=$CONTAINER_REGISTRY_NAME" \
    -var="key_vault_name=$KEY_VAULT_NAME"

# Apply deployment
terraform apply -auto-approve \
    -var="resource_group_name=$RESOURCE_GROUP_NAME" \
    -var="location=$LOCATION" \
    -var="app_name=$APP_NAME" \
    -var="container_registry_name=$CONTAINER_REGISTRY_NAME" \
    -var="key_vault_name=$KEY_VAULT_NAME"

# Output important values
echo "Infrastructure deployed successfully!"
echo "App Service URL: $(terraform output -raw app_service_url)"
echo "API Management URL: $(terraform output -raw api_management_url)"
echo "Client ID: $(terraform output -raw app_registration_client_id)"

cd ..