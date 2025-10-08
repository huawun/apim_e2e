#!/bin/bash
set -e

echo "Setting up Azure prerequisites..."

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Azure CLI not found. Please install it first."
    exit 1
fi

# Login to Azure
echo "Logging into Azure..."
az login

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "Please create .env file from .env.example"
    exit 1
fi

# Set subscription
az account set --subscription $AZURE_SUBSCRIPTION_ID

# Create resource group
echo "Creating resource group..."
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create service principal for automation
echo "Creating service principal..."
SP_OUTPUT=$(az ad sp create-for-rbac --name "sp-$APP_NAME" \
    --role Contributor \
    --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME \
    --json-auth)

echo "Service Principal created. Update your .env file with:"
echo "AZURE_CLIENT_ID=$(echo $SP_OUTPUT | jq -r '.clientId')"
echo "AZURE_CLIENT_SECRET=$(echo $SP_OUTPUT | jq -r '.clientSecret')"

echo "Prerequisites setup complete!"