#!/bin/bash
set -e

echo "Setting up Azure DevOps integration..."

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "Please create .env file from .env.example"
    exit 1
fi

# Create service connection in Azure DevOps
echo "Creating Azure DevOps service connection..."
echo "1. Go to Azure DevOps Project Settings > Service connections"
echo "2. Create new Azure Resource Manager connection"
echo "3. Use Service Principal (manual) with these details:"
echo "   - Subscription ID: $AZURE_SUBSCRIPTION_ID"
echo "   - Subscription Name: Your subscription name"
echo "   - Service Principal ID: $AZURE_CLIENT_ID"
echo "   - Service Principal Key: $AZURE_CLIENT_SECRET"
echo "   - Tenant ID: $AZURE_TENANT_ID"
echo "   - Connection Name: azure-service-connection"

echo ""
echo "Pipeline Variables to set in Azure DevOps:"
echo "- APP_NAME: $APP_NAME"
echo "- RESOURCE_GROUP_NAME: $RESOURCE_GROUP_NAME"
echo "- LOCATION: $LOCATION"
echo "- CONTAINER_REGISTRY_NAME: $CONTAINER_REGISTRY_NAME"
echo "- KEY_VAULT_NAME: $KEY_VAULT_NAME"

echo ""
echo "Setup complete! Import the pipeline YAML files in Azure DevOps."