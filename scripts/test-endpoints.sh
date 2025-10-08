#!/bin/bash
set -e

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "Please create .env file from .env.example"
    exit 1
fi

APP_URL="https://$APP_NAME.azurewebsites.net"
APIM_URL=$(cd terraform && terraform output -raw api_management_url)

echo "Testing endpoints..."

# Test health endpoint
echo "Testing health endpoint..."
curl -s "$APP_URL/health" | jq .

# Test API Management health endpoint
echo "Testing API Management health endpoint..."
curl -s "$APIM_URL/api/health" | jq .

echo "Endpoint tests completed!"