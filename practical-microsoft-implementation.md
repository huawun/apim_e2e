# Practical Implementation Guide

## How Teams Actually Work Day-to-Day

### PHASE 1: REQUEST & PLANNING

**What Teams Use:**
- **Jira**: Submit application request ticket
- **Microsoft Teams**: Stakeholder discussions
- **SharePoint**: Store requirements documents
- **Azure DevOps Boards**: Track work items

**Actual Steps:**
```
1. Business Owner creates Jira ticket:
   - Template: "New Application Request"
   - Includes: Business justification, user count, compliance needs

2. Solution Architect reviews in weekly architecture board meeting
   - Uses Visio/Draw.io for architecture diagrams
   - Creates Azure DevOps Epic with technical requirements

3. Security team gets auto-assigned ticket for review
```

### PHASE 2: SECURITY SETUP

**What Teams Use:**
- **Azure Portal**: Entra ID management
- **PowerShell/Azure CLI**: Automation scripts
- **Azure DevOps**: Store security templates
- **Jira**: Security approval workflow

**Actual Steps:**
```
Security Team Daily Tasks:

1. Login to Azure Portal → Entra ID
2. App registrations → New registration
   - Name: "MyApp-Production"
   - Redirect URIs: https://myapp.company.com/auth/callback
   - API permissions: Microsoft Graph (User.Read)

3. Create PowerShell script (stored in Azure DevOps):
   ```powershell
   # Create App Registration
   $app = New-AzADApplication -DisplayName "MyApp-Production"
   
   # Create Service Principal
   $sp = New-AzADServicePrincipal -ApplicationId $app.AppId
   
   # Assign permissions
   Add-AzADAppPermission -ObjectId $app.Id -ApiId "00000003-0000-0000-c000-000000000000" -PermissionId "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
   ```

4. Update Jira ticket: "Security setup complete"
```

### PHASE 3: INFRASTRUCTURE

**What Teams Use:**
- **Azure DevOps Pipelines**: Infrastructure as Code
- **Terraform/ARM Templates**: Resource definitions
- **Azure Portal**: Manual verification
- **Slack/Teams**: Team notifications

**Actual Daily Workflow:**
```
Platform Team Morning Routine:

1. Check Azure DevOps Pipeline notifications
2. Review failed deployments from overnight

Infrastructure Deployment:
1. Pull latest Terraform code from Azure DevOps Git
2. Run pipeline: "Deploy-Infrastructure-Production"
   
   Pipeline YAML:
   ```yaml
   trigger:
   - main
   
   pool:
     vmImage: 'ubuntu-latest'
   
   steps:
   - task: TerraformInstaller@0
   - task: TerraformTaskV3@3
     inputs:
       command: 'apply'
       workingDirectory: '$(System.DefaultWorkingDirectory)/terraform'
   ```

3. Verify in Azure Portal:
   - Resource Group created ✅
   - Key Vault accessible ✅
   - App Service running ✅

4. Post in Teams channel: "Infrastructure ready for MyApp"
```

### PHASE 4: DEVELOPMENT

**What Teams Use:**
- **Visual Studio/VS Code**: Development
- **Azure DevOps Git**: Source control
- **Docker Desktop**: Local container testing
- **Postman**: API testing

**Developer Daily Tasks:**
```
Morning Standup (Teams call):
- "Working on Entra ID integration today"
- "Blocked on Key Vault permissions"

Actual Coding:
1. Open VS Code
2. Pull latest from Azure DevOps Git
3. Install NuGet packages:
   ```xml
   <PackageReference Include="Microsoft.Identity.Web" Version="2.13.0" />
   <PackageReference Include="Azure.Security.KeyVault.Secrets" Version="4.5.0" />
   ```

4. Write authentication code:
   ```csharp
   // Startup.cs
   services.AddMicrosoftIdentityWebApiAuthentication(Configuration);
   
   // Get secrets from Key Vault
   var client = new SecretClient(new Uri("https://myvault.vault.azure.net/"), new DefaultAzureCredential());
   var secret = await client.GetSecretAsync("DatabaseConnectionString");
   ```

5. Test locally with Docker:
   ```bash
   docker build -t myapp .
   docker run -p 8080:80 myapp
   ```

6. Commit to Azure DevOps Git
7. Create Pull Request for code review
```

### PHASE 5: DEPLOYMENT

**What Teams Use:**
- **Azure DevOps Release Pipelines**: Automated deployment
- **Azure Portal**: Monitor deployments
- **Application Insights**: Real-time monitoring

**DevOps Engineer Daily Tasks:**
```
1. Check overnight deployment status in Azure DevOps
2. Review failed releases and fix issues

Deployment Process:
1. Approve Pull Request in Azure DevOps
2. Automatic trigger of Release Pipeline
3. Pipeline steps:
   - Build Docker image
   - Push to Azure Container Registry
   - Deploy to App Service staging slot
   - Run smoke tests
   - Swap to production slot

4. Monitor in Azure Portal:
   - App Service → Deployment Center
   - Check health endpoint: https://myapp.company.com/health

5. Update Jira ticket: "Deployment complete"
```

### PHASE 6: API MANAGEMENT

**What Teams Use:**
- **Azure Portal**: APIM configuration
- **Swagger/OpenAPI**: API documentation
- **Postman**: API testing

**API Team Daily Tasks:**
```
1. Login to Azure Portal → API Management
2. Import API definition:
   - Backend URL: https://myapp-internal.azurewebsites.net
   - OpenAPI spec from developer

3. Configure policies:
   ```xml
   <policies>
       <inbound>
           <rate-limit calls="100" renewal-period="60" />
           <validate-jwt header-name="Authorization" failed-validation-httpcode="401">
               <openid-config url="https://login.microsoftonline.com/{tenant}/.well-known/openid_configuration" />
           </validate-jwt>
       </inbound>
   </policies>
   ```

4. Test with Postman:
   - GET https://api.company.com/myapp/users
   - Verify rate limiting works
   - Check authentication

5. Publish to Developer Portal for external users
```

### PHASE 7: MONITORING & OPERATIONS

**What Teams Use:**
- **Azure Monitor**: Dashboards and alerts
- **Application Insights**: Performance monitoring
- **Jira**: Incident management
- **Teams**: Alert notifications

**Operations Team Daily Tasks:**
```
Morning Health Check:
1. Open Azure Portal → Monitor → Dashboards
2. Review overnight alerts in Teams channel
3. Check Application Insights for errors:
   - Exceptions > 0? → Create Jira incident
   - Response time > 2s? → Investigate

Alert Configuration:
1. Azure Monitor → Alerts → New alert rule
2. Target: App Service "MyApp-Production"
3. Condition: HTTP 5xx errors > 5 in 5 minutes
4. Action: Send to Teams channel + Email on-call engineer

Weekly Review:
1. Generate performance report from Application Insights
2. Share in Teams channel with development team
3. Update capacity planning spreadsheet
```

## Team Communication Patterns

**Daily Standups (Teams):**
- Security: "Approved 3 app registrations yesterday"
- Platform: "Infrastructure pipeline failed, fixing networking issue"
- Dev: "Authentication working, need Key Vault permissions"
- DevOps: "Deployed to staging, ready for production"

**Weekly Reviews:**
- Architecture board meeting (Teams)
- Security review meeting (Teams)
- Operations review (Jira dashboard)

**Escalation Process:**
```
Issue → Teams channel → Jira ticket → Manager escalation → Executive notification
```

## Tools Integration Map

```
Jira ←→ Azure DevOps ←→ Azure Portal ←→ Teams
    ↓              ↓              ↓         ↓
 Approvals    Code/Pipelines   Resources  Notifications
```

This shows exactly how your teams will use familiar Microsoft tools to implement the workflow in their daily operations.
