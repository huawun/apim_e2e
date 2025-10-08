#!/bin/bash
set -e

echo "Deploying application..."

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "Please create .env file from .env.example"
    exit 1
fi

# Login to Azure
az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
az account set --subscription $AZURE_SUBSCRIPTION_ID

# Login to Container Registry
echo "Logging into Container Registry..."
az acr login --name $CONTAINER_REGISTRY_NAME

# Build and push Docker image
echo "Building and pushing Docker image..."
cd src
docker build -t $CONTAINER_REGISTRY_NAME.azurecr.io/$APP_NAME:latest .
docker push $CONTAINER_REGISTRY_NAME.azurecr.io/$APP_NAME:latest

# Update App Service configuration
echo "Updating App Service..."
az webapp config container set \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --docker-custom-image-name $CONTAINER_REGISTRY_NAME.azurecr.io/$APP_NAME:latest

# Restart App Service
echo "Restarting App Service..."
az webapp restart --name $APP_NAME --resource-group $RESOURCE_GROUP_NAME

echo "Application deployed successfully!"
echo "App URL: https://$APP_NAME.azurewebsites.net"

cd ..