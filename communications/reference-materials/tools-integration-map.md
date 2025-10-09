# Tools Integration Map - Azure E2E Workflow

Complete guide to how all tools connect and integrate in the workflow.

---

## Tools Ecosystem Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         TOOLS ECOSYSTEM MAP                                  │
└─────────────────────────────────────────────────────────────────────────────┘

Project Management Layer
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────┐         ┌──────────┐         ┌──────────┐
    │   Jira   │◀───────▶│  Azure   │◀───────▶│  Teams   │
    │          │  API    │  DevOps  │  Webhook│          │
    └────┬─────┘         └────┬─────┘         └────┬─────┘
         │                    │                     │
         │ Tickets            │ Work Items          │ Notifications
         │                    │                     │
         └────────────────────┴─────────────────────┘
                              │
                              ▼
                        ALL TEAMS

Development & Source Control
═══════════════════────────────────════════════════════════════════════════════
    ┌──────────┐         ┌──────────┐         ┌──────────┐
    │   Git    │◀───────▶│  GitHub  │         │   VS     │
    │  (Local) │  Push   │   or     │◀───────▶│  Code    │
    │          │  Pull   │Azure Repos│  Clone  │          │
    └────┬─────┘         └────┬─────┘         └──────────┘
         │                    │
         │                    │ Webhooks
         │                    ▼
         │             ┌──────────┐
         │             │  Azure   │
         │             │ DevOps   │
         │             │ Pipelines│
         │             └──────────┘
         │
         └─────────────────────────────────────────────────┐
                                                            │
Cloud Platform                                              │
═══════════════════════════════════════════════════════════╧═══════════════════
    ┌──────────┐         ┌──────────┐         ┌──────────┐
    │  Azure   │◀───────▶│Terraform │◀───────▶│  Azure   │
    │  Portal  │  API    │   or     │  State  │ Storage  │
    │          │         │   ARM    │         │          │
    └────┬─────┘         └────┬─────┘         └──────────┘
         │                    │
         │ Resources          │ IaC
         │                    │
         └────────────────────┴─────────────────────────────┐
                                                             │
Identity & Security                                          │
═══════════════════════════════════════════════════════════╧════════════════════
    ┌──────────┐         ┌──────────┐         ┌──────────┐
    │ Entra ID │◀───────▶│   Key    │◀───────▶│Managed   │
    │  (AAD)   │  Auth   │  Vault   │  Access │Identity  │
    └────┬─────┘         └────┬─────┘         └────┬─────┘
         │                    │                     │
         │ Tokens             │ Secrets             │ Auth
         │                    │                     │
         └────────────────────┴─────────────────────┘
                              │
                              ▼
                        APPLICATIONS

API Management & Governance
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────┐         ┌──────────┐         ┌──────────┐
    │   API    │◀───────▶│   API    │◀───────▶│Developer │
    │  Center  │  Link   │   Mgmt   │  Publish│  Portal  │
    │          │         │  (APIM)  │         │          │
    └──────────┘         └────┬─────┘         └──────────┘
                              │
                              │ Gateway
                              ▼
                        APPLICATIONS

Monitoring & Observability
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────┐         ┌──────────┐         ┌──────────┐
    │   App    │────────▶│   Log    │────────▶│  Azure   │
    │ Insights │  Logs   │Analytics │  Query  │  Monitor │
    └────┬─────┘         └────┬─────┘         └────┬─────┘
         │                    │                     │
         │ Telemetry          │ Logs                │ Alerts
         │                    │                     │
         └────────────────────┴─────────────────────┘
                              │
                              ▼
                        OPS TEAM
```

---

## Integration Details by Tool

### Jira Integration

**Purpose**: Project tracking and approval workflow

**Integrates With**:
```
1. Azure DevOps
   - Connection: API integration
   - Data Flow: Jira tickets → Azure DevOps work items
   - Use Case: Sync requirements and track development

2. Microsoft Teams
   - Connection: Jira Cloud app
   - Data Flow: Ticket updates → Teams notifications
   - Use Case: Real-time updates to team channels

3. Email
   - Connection: SMTP
   - Data Flow: Ticket events → Email notifications
   - Use Case: Notify stakeholders of approvals

4. SharePoint
   - Connection: Manual/Power Automate
   - Data Flow: Attach documents from SharePoint
   - Use Case: Link requirements documents
```

**Configuration**:
```
Jira → Settings → Apps → Azure DevOps integration
- API Token: [stored in Key Vault]
- Sync: Bidirectional
- Fields: Status, Assignee, Comments

Jira → Settings → Notifications
- Events: Status change, Comment added
- Channels: Teams webhook, Email
```

---

### Azure DevOps Integration

**Purpose**: CI/CD and work tracking

**Integrates With**:
```
1. Git/GitHub
   - Connection: Built-in or service connection
   - Data Flow: Code commits → Pipeline triggers
   - Use Case: Source control integration

2. Azure Portal
   - Connection: Azure subscription service connection
   - Data Flow: Pipeline → Resource deployment
   - Use Case: Deploy Azure resources

3. Docker Registry
   - Connection: Service connection
   - Data Flow: Build → Push images
   - Use Case: Container management

4. Azure Key Vault
   - Connection: Variable groups
   - Data Flow: Pipeline → Retrieve secrets
   - Use Case: Secure credential management

5. Terraform
   - Connection: Pipeline tasks
   - Data Flow: IaC → Azure resources
   - Use Case: Infrastructure provisioning

6. Teams
   - Connection: Webhook
   - Data Flow: Pipeline status → Teams notifications
   - Use Case: Build/deployment alerts
```

**Configuration**:
```yaml
# Azure DevOps Pipeline - Service Connections
service_connections:
  - name: Azure-Prod
    type: AzureRM
    auth: Service Principal
    
  - name: ACR-Connection
    type: Docker Registry
    registry: myacr.azurecr.io
    
  - name: KeyVault-Secrets
    type: Azure Key Vault
    vault: myapp-prod-kv
```

---

### Azure Portal Integration

**Purpose**: Cloud resource management

**Integrates With**:
```
1. Entra ID
   - Connection: Built-in
   - Data Flow: Identity management
   - Use Case: App registrations, users, groups

2. Azure CLI/PowerShell
   - Connection: REST API
   - Data Flow: Automation scripts → Azure
   - Use Case: Scripted operations

3. Terraform
   - Connection: Azure Provider
   - Data Flow: IaC → Azure resources
   - Use Case: Infrastructure as Code

4. Application Insights
   - Connection: Built-in
   - Data Flow: Telemetry → Portal dashboards
   - Use Case: Monitoring and analytics

5. Azure DevOps
   - Connection: Service connections
   - Data Flow: Pipelines → Resource deployment
   - Use Case: Automated deployment
```

**Configuration**:
```powershell
# PowerShell - Azure Connection
Connect-AzAccount
Set-AzContext -Subscription "Production"

# Azure CLI - Azure Connection
az login
az account set --subscription "Production"
```

---

### Microsoft Teams Integration

**Purpose**: Team communication and collaboration

**Integrates With**:
```
1. Jira
   - Connection: Jira Cloud app
   - Data Flow: Tickets → Teams messages
   - Use Case: Ticket notifications

2. Azure DevOps
   - Connection: Azure Pipelines app
   - Data Flow: Build status → Teams messages
   - Use Case: Pipeline notifications

3. Azure Monitor
   - Connection: Webhook
   - Data Flow: Alerts → Teams messages
   - Use Case: Production alerts

4. SharePoint
   - Connection: Built-in (O365)
   - Data Flow: Share files/documents
   - Use Case: Document collaboration

5. Power Automate
   - Connection: Connectors
   - Data Flow: Workflow automation
   - Use Case: Custom integrations
```

**Configuration**:
```
Teams Channel: #enterprise-applications

Incoming Webhooks:
- Jira: https://teams.webhook.office.com/jira-notifications
- Azure DevOps: https://teams.webhook.office.com/pipeline-status
- Azure Monitor: https://teams.webhook.office.com/prod-alerts

Apps Installed:
- Jira Cloud
- Azure Pipelines
- Azure Boards
```

---

### Docker Integration

**Purpose**: Containerization

**Integrates With**:
```
1. Azure Container Registry
   - Connection: Docker login
   - Data Flow: Local build → ACR
   - Use Case: Store container images

2. Azure DevOps
   - Connection: Docker@2 task
   - Data Flow: Pipeline → Build/push images
   - Use Case: Automated container builds

3. Azure App Service
   - Connection: Deployment configuration
   - Data Flow: ACR → App Service
   - Use Case: Container deployment

4. Docker Hub
   - Connection: Docker login (optional)
   - Data Flow: Pull base images
   - Use Case: Base image sourcing
```

**Configuration**:
```dockerfile
# Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY . .
EXPOSE 80
ENTRYPOINT ["dotnet", "MyApp.dll"]
```

```bash
# Docker Commands
docker build -t myapp .
docker tag myapp myacr.azurecr.io/myapp:latest
docker push myacr.azurecr.io/myapp:latest
```

---

### Terraform Integration

**Purpose**: Infrastructure as Code

**Integrates With**:
```
1. Azure Provider
   - Connection: Service Principal
   - Data Flow: Terraform → Azure resources
   - Use Case: Provision infrastructure

2. Azure DevOps
   - Connection: Terraform tasks
   - Data Flow: Pipeline → Terraform execution
   - Use Case: Automated IaC deployment

3. Azure Storage
   - Connection: Backend configuration
   - Data Flow: Terraform state → Blob storage
   - Use Case: State management

4. Azure Key Vault
   - Connection: Data source
   - Data Flow: Key Vault → Terraform variables
   - Use Case: Secret retrieval
```

**Configuration**:
```hcl
# Terraform Backend
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

# Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
```

---

### Application Insights Integration

**Purpose**: Application monitoring

**Integrates With**:
```
1. Application Code
   - Connection: SDK
   - Data Flow: App telemetry → App Insights
   - Use Case: Performance monitoring

2. Azure Monitor
   - Connection: Built-in
   - Data Flow: Metrics → Alerts
   - Use Case: Alert configuration

3. Log Analytics
   - Connection: Built-in
   - Data Flow: Logs → Query workspace
   - Use Case: Advanced analytics

4. Power BI
   - Connection: Export
   - Data Flow: Metrics → BI reports
   - Use Case: Executive dashboards

5. Teams
   - Connection: Webhook
   - Data Flow: Alerts → Teams notifications
   - Use Case: Incident alerts
```

**Configuration**:
```csharp
// Application Code
services.AddApplicationInsightsTelemetry(
    Configuration["ApplicationInsights:InstrumentationKey"]);

// Custom Telemetry
telemetryClient.TrackEvent("UserLogin", properties);
telemetryClient.TrackMetric("ProcessingTime", duration);
```

---

### API Management Integration

**Purpose**: API gateway and security

**Integrates With**:
```
1. Backend APIs
   - Connection: Backend configuration
   - Data Flow: APIM → App Service
   - Use Case: API routing

2. Entra ID
   - Connection: JWT validation policy
   - Data Flow: Token validation
   - Use Case: Authentication

3. API Center
   - Connection: Metadata link
   - Data Flow: Registration info
   - Use Case: Governance tracking

4. Developer Portal
   - Connection: Built-in
   - Data Flow: API definitions → Portal
   - Use Case: Developer documentation

5. Application Insights
   - Connection: Logger policy
   - Data Flow: Request metrics → Insights
   - Use Case: API analytics
```

**Configuration**:
```xml
<!-- APIM Policy -->
<policies>
    <inbound>
        <validate-jwt header-name="Authorization">
            <openid-config url="https://login.microsoftonline.com/{tenant}/.well-known/openid-configuration" />
        </validate-jwt>
        <rate-limit calls="100" renewal-period="60" />
    </inbound>
    <backend>
        <forward-request />
    </backend>
    <outbound>
        <set-header name="X-Powered-By" exists-action="delete" />
    </outbound>
</policies>
```

---

## Data Flow Patterns

### Pattern 1: Ticket to Deployment

```
Jira Ticket
    │
    │ 1. Create ticket
    ▼
Azure DevOps Work Item (synced)
    │
    │ 2. Link to code
    ▼
Git Commit (with work item #)
    │
    │ 3. Trigger build
    ▼
Azure DevOps Pipeline
    │
    │ 4. Build & deploy
    ▼
Azure Resources
    │
    │ 5. Notify completion
    ▼
Teams Notification
    │
    │ 6. Update ticket
    ▼
Jira Ticket (status updated)
```

### Pattern 2: Code to Production

```
Developer Workstation
    │
    │ 1. Write code
    ▼
Git Push to Azure Repos
    │
    │ 2. Trigger CI
    ▼
Build Pipeline
    │
    │ 3. Build Docker image
    ▼
Azure Container Registry
    │
    │ 4. Trigger CD
    ▼
Release Pipeline
    │
    │ 5. Deploy container
    ▼
Azure App Service
    │
    │ 6. Send telemetry
    ▼
Application Insights
    │
    │ 7. Monitor & alert
    ▼
Operations Team (Teams notification)
```

### Pattern 3: Security Approval Flow

```
Identity Team (Azure Portal)
    │
    │ 1. Create app registration
    ▼
Jira Ticket (update)
    │
    │ 2. Notify security
    ▼
Security Team (Azure Portal)
    │
    │ 3. Review permissions
    ▼
Conditional Access Policy (configured)
    │
    │ 4. Grant consent
    ▼
App Registration (permissions approved)
    │
    │ 5. Update ticket
    ▼
Jira Ticket (approved status)
    │
    │ 6. Notify dev team
    ▼
Teams Notification
```

---

## Authentication & Authorization

### Tool-to-Tool Authentication

```
Tool A           Authentication Method           Tool B
─────────────────────────────────────────────────────────────────
Azure DevOps  →  Service Principal          →  Azure Portal
Azure DevOps  →  API Token                  →  Jira
Azure DevOps  →  Docker Registry Token      →  ACR
PowerShell    →  Az Login / Service Principal →  Azure
Terraform     →  Service Principal          →  Azure
APIM          →  Managed Identity           →  Key Vault
App Service   →  Managed Identity           →  Key Vault
Developer     →  Entra ID Token             →  APIM
Pipeline      →  Variable Group (Key Vault) →  Secrets
```

### Credential Management

```
┌──────────────┐
│  Key Vault   │  ← Central secret store
└──────┬───────┘
       │
       ├──▶ Azure DevOps (Variable Groups)
       ├──▶ Application Code (SDK)
       ├──▶ Terraform (Data Source)
       └──▶ PowerShell Scripts (Az cmdlets)

Stored Secrets:
- API tokens
- Connection strings
- Service principal credentials
- Certificate passwords
- Third-party API keys
```

---

## Tool Access Matrix

| Tool | Who Needs Access | Access Level | Auth Method |
|------|-----------------|-------------|-------------|
| Jira | All teams | Varies by role | SSO (Entra ID) |
| Azure DevOps | Dev, DevOps, Platform | Contributor | SSO (Entra ID) |
| Azure Portal | All teams | Varies by role | Entra ID |
| Teams | All teams | Member | SSO (O365) |
| GitHub/Git | Dev, DevOps | Contributor | SSH/PAT |
| Terraform | Platform team | N/A | Service Principal |
| Docker | Dev, DevOps | N/A | Local install |
| VS Code | Developers | N/A | Local install |
| PowerShell | Identity, Security, Platform | N/A | Local install |
| Postman | Dev, API teams | N/A | Local install |

---

## Troubleshooting Integration Issues

### Common Issues

**Issue**: Azure DevOps can't deploy to Azure
```
Cause: Service connection expired
Fix: Azure DevOps → Project Settings → Service Connections
     → Verify/renew service principal
```

**Issue**: Docker push fails to ACR
```
Cause: Not authenticated
Fix: az acr login --name myacr
     Or: docker login myacr.azurecr.io -u <username> -p <password>
```

**Issue**: Terraform state locked
```
Cause: Previous operation didn't complete
Fix: terraform force-unlock <lock-id>
     Or: Manually delete lease in Azure Storage
```

**Issue**: Teams webhook not receiving notifications
```
Cause: Webhook expired or revoked
Fix: Regenerate webhook in Teams channel
     Update webhook URL in source system
```

**Issue**: Jira-Azure DevOps sync not working
```
Cause: API token invalid
Fix: Regenerate API token in Jira
     Update in Azure DevOps integration settings
```

---

**Document Owner**: PMO Team  
**Last Updated**: January 2025  
**Maintenance**: Review quarterly for tool updates  

---

*This integration map ensures all teams understand how tools connect and can troubleshoot integration issues effectively.*
