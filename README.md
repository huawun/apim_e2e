# Azure End-to-End Production Workflow

This repository demonstrates a complete production-grade workflow from Azure app registration to application deployment and usage.

## Architecture Overview

```
App Registration → Key Vault → Container Registry → App Service → API Management → Monitoring
```

## Quick Start

1. **Prerequisites Setup**:
   ```bash
   ./scripts/setup-prerequisites.sh
   ```

2. **Deploy Infrastructure**:
   ```bash
   ./scripts/deploy-infrastructure.sh
   ```

3. **Deploy Application**:
   ```bash
   ./scripts/deploy-application.sh
   ```

## Components

- **Infrastructure**: Terraform configurations for Azure resources
- **Application**: Sample .NET API with Azure AD integration
- **CI/CD**: Azure DevOps Pipelines for automated deployment
- **Monitoring**: Application Insights and Log Analytics
- **Security**: Key Vault integration and managed identities

## Environment Variables

Copy `.env.example` to `.env` and configure:
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID` 
- `RESOURCE_GROUP_NAME`
- `LOCATION`

## Workflow Steps

1. App registration with required permissions
2. Infrastructure provisioning (Key Vault, App Service, APIM)
3. Application build and containerization
4. Deployment with managed identity
5. API Management configuration
6. Monitoring setup