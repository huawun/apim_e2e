# Identity Team - Communication Deck

## 🎯 Your Role in the Workflow

As part of the **Identity Team**, you are responsible for the **technical implementation of Entra ID configurations**. You create and configure app registrations, service principals, and authentication flows, working alongside the Security Team in a hybrid model.

---

## 📋 Your Primary Responsibilities

### What You Own
1. **App Registration Creation**: Create and configure Entra ID app registrations
2. **Service Principal Management**: Set up service principals for Azure resources
3. **Authentication Flow Configuration**: Configure OAuth2, OIDC, SAML flows
4. **User Group Management**: Create and manage Entra ID groups
5. **Automation**: Maintain PowerShell/CLI scripts for identity operations

### What Security Team Owns (Hybrid Model)
- API permission approval and admin consent
- Conditional access policy configuration
- Security policy enforcement
- High-privilege permission grants

### What Success Looks Like
- ✅ App registrations created within 2 business days
- ✅ All configurations follow security standards
- ✅ Automation scripts maintained and documented
- ✅ Zero authentication-related production issues
- ✅ Smooth handoff to Security Team for approvals

---

## 🛠️ Tools You'll Use Daily

### Primary Tools
| Tool | Purpose | Your Daily Use |
|------|---------|---------------|
| **Azure Portal** | Entra ID management | Create app registrations, manage groups |
| **PowerShell** | Automation | Run identity scripts, bulk operations |
| **Azure CLI** | Automation alternative | Quick CLI operations |
| **Azure DevOps** | Script repository | Store and version control scripts |
| **Microsoft Teams** | Communication | Coordinate with Security Team |
| **Jira** | Ticket tracking | Track identity requests, approvals |

### Tool Access Required
- [ ] Azure Portal - Entra ID administrator role
- [ ] PowerShell with Azure AD module installed
- [ ] Azure CLI installed and configured
- [ ] Azure DevOps repository access
- [ ] Teams access to #identity-team channel
- [ ] Jira access with identity project permissions

---

## 🔄 Your Workflow: Step-by-Step

### Phase 2: Identity Configuration (YOUR PRIMARY PHASE)

#### Step 1: Receive and Review Request
**Time Required**: 30 minutes

```
Input from Jira:
├─ Application name
├─ Environment (Dev/Test/Prod)
├─ Authentication requirements
├─ User types (internal/external)
└─ Required API permissions (pending Security approval)

Your Initial Review:
├─ Verify naming conventions
├─ Check for existing similar apps
├─ Validate authentication flow
└─ Prepare for configuration
```

#### Step 2: Create App Registration
**Time Required**: 1-2 hours

**Manual Process (Azure Portal):**

```
1. Login to Azure Portal → Entra ID → App registrations

2. Click "New registration"

3. Fill in details:
   ┌─────────────────────────────────────────────────────┐
   │ App Registration Configuration                       │
   ├─────────────────────────────────────────────────────┤
   │ Name: MyApp-Production                              │
   │ (Follow naming: [AppName]-[Environment])            │
   │                                                      │
   │ Supported account types:                            │
   │ ● Single tenant (most common)                       │
   │ ○ Multi-tenant                                      │
   │ ○ Personal Microsoft accounts                       │
   │                                                      │
   │ Redirect URI (optional - can add later):            │
   │ Platform: Web                                        │
   │ URI: https://myapp.company.com/auth/callback        │
   └─────────────────────────────────────────────────────┘

4. Click "Register"

5. Note down:
   - Application (client) ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   - Directory (tenant) ID: yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy
```

**Automated Process (PowerShell):**

```powershell
# identity-scripts/create-app-registration.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$AppName,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet('Dev','Test','Prod')]
    [string]$Environment,
    
    [Parameter(Mandatory=$false)]
    [string[]]$RedirectUris
)

# Connect to Azure AD
Connect-AzAccount

# Create app registration
$displayName = "$AppName-$Environment"
$app = New-AzADApplication -DisplayName $displayName `
    -SignInAudience "AzureADMyOrg"

# Add redirect URIs if provided
if ($RedirectUris) {
    $webApp = @{
        RedirectUris = $RedirectUris
    }
    Update-AzADApplication -ObjectId $app.Id -Web $webApp
}

# Create service principal
$sp = New-AzADServicePrincipal -ApplicationId $app.AppId

# Output credentials
Write-Host "App Registration Created Successfully!" -ForegroundColor Green
Write-Host "Application ID: $($app.AppId)"
Write-Host "Object ID: $($app.Id)"
Write-Host "Tenant ID: $(Get-AzContext).Tenant.Id"
Write-Host ""
Write-Host "Save these values securely!"

# Log to audit file
$auditEntry = @{
    Timestamp = Get-Date
    AppName = $displayName
    AppId = $app.AppId
    CreatedBy = $(Get-AzContext).Account.Id
} | ConvertTo-Json

Add-Content -Path "audit-log.json" -Value $auditEntry
```

**Usage:**
```powershell
.\create-app-registration.ps1 -AppName "MyApp" -Environment "Prod" `
    -RedirectUris @("https://myapp.company.com/auth/callback")
```

#### Step 3: Configure Authentication Settings
**Time Required**: 30 minutes

```
Azure Portal → App Registration → Authentication

1. Platform configurations:
   - Add platform (Web, SPA, Mobile/Desktop)
   - Configure redirect URIs
   - Set logout URL

2. Implicit grant and hybrid flows:
   ☐ Access tokens (for implicit flows)
   ☐ ID tokens (for implicit flows)
   
   Note: Modern apps should use Auth Code Flow instead

3. Advanced settings:
   ☑ Allow public client flows (for mobile/desktop)
   ☑ Enable ID token for hybrid and implicit flows
   
4. Supported account types:
   ● Accounts in this organizational directory only
```

#### Step 4: Configure API Permissions (Prepare for Security)
**Time Required**: 30 minutes

**IMPORTANT**: You configure the permissions, but Security Team must approve!

```
Azure Portal → App Registration → API permissions

1. Click "Add a permission"

2. Select API:
   - Microsoft Graph (most common)
   - Other Microsoft APIs
   - Company internal APIs

3. Add required permissions:
   Example for Microsoft Graph:
   ┌───────────────────────────────────────────┐
   │ Delegated Permissions (user context):     │
   │ ☑ User.Read (sign in and read profile)   │
   │ ☑ User.ReadBasic.All (read all profiles) │
   │                                            │
   │ Application Permissions (app context):    │
   │ ☑ User.Read.All (read all user profiles) │
   └───────────────────────────────────────────┘

4. Click "Add permissions"

5. **DO NOT grant admin consent** - This is Security Team's role!

6. Update Jira ticket: "Ready for Security review"
   @mention Security Team in ticket
```

#### Step 5: Create User Groups (if needed)
**Time Required**: 30 minutes

```powershell
# Create Entra ID group for app users
$groupParams = @{
    DisplayName = "MyApp-Users-Prod"
    MailEnabled = $false
    SecurityEnabled = $true
    MailNickname = "MyAppUsersProd"
    Description = "Users with access to MyApp Production"
}

$group = New-AzADGroup @groupParams

# Add initial members (if specified)
$userIds = @(
    "user1@company.com",
    "user2@company.com"
)

foreach ($userId in $userIds) {
    $user = Get-AzADUser -UserPrincipalName $userId
    Add-AzADGroupMember -TargetGroupObjectId $group.Id `
        -MemberObjectId $user.Id
}

Write-Host "Group created: $($group.DisplayName)"
Write-Host "Group ID: $($group.Id)"
```

#### Step 6: Documentation and Handoff
**Time Required**: 30 minutes

**Update Azure DevOps:**

```markdown
# MyApp Identity Configuration

## App Registration Details
- **Name**: MyApp-Production
- **Application ID**: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
- **Object ID**: yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy
- **Tenant ID**: zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz

## Authentication Configuration
- **Redirect URIs**: 
  - https://myapp.company.com/auth/callback
  - https://myapp.company.com/auth/silent-renew
- **Logout URL**: https://myapp.company.com/logout
- **Token lifetime**: Default (1 hour)

## API Permissions (Awaiting Security Approval)
| API | Permission | Type | Reason |
|-----|-----------|------|--------|
| Microsoft Graph | User.Read | Delegated | User profile access |
| Microsoft Graph | User.ReadBasic.All | Delegated | Directory search |

## User Groups
- **Group Name**: MyApp-Users-Prod
- **Group ID**: aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
- **Member Count**: 15

## Next Steps
1. Security Team: Review and approve API permissions
2. Security Team: Grant admin consent
3. Security Team: Configure conditional access policies
4. Dev Team: Integrate authentication in application

## Scripts Used
- Location: Azure DevOps → identity-scripts repo
- Scripts: create-app-registration.ps1, create-user-groups.ps1

## Audit Trail
- Created by: identity-admin@company.com
- Created date: 2025-01-15
- Jira ticket: PROJ-1234
```

**Update Jira Ticket:**
```
Status: Identity Configuration Complete - Ready for Security Review

Configuration Details:
✅ App registration created
✅ Authentication settings configured
✅ API permissions added (awaiting approval)
✅ User groups created
✅ Documentation updated in Azure DevOps

@Security-Team - Ready for your review and approval:
1. Review API permissions
2. Grant admin consent if approved
3. Configure conditional access policies

All credentials and IDs documented in Azure DevOps: [link]
```

---

## 📊 Your Involvement by Phase

```
Phase 1: REQUEST & PLANNING
YOUR REVIEW ROLE: 10% involvement
└─ Review identity requirements from Jira

Phase 2: SECURITY & IDENTITY
YOUR LEAD ROLE: 70% involvement (Technical Implementation)
├─ Create app registration ✓ YOU
├─ Configure authentication ✓ YOU
├─ Add API permissions (no consent) ✓ YOU
├─ Create service principal ✓ YOU
├─ Create user groups ✓ YOU
└─ Document configuration ✓ YOU

(Security Team: 30% - Approval & Policies)
├─ Review permissions
├─ Grant admin consent
└─ Configure conditional access

Phase 2A: API DESIGN & GOVERNANCE
YOUR SUPPORT ROLE: 5% involvement
└─ Provide identity info for API registration

Phase 3-7: All Other Phases
YOUR SUPPORT ROLE: 5% involvement
└─ Answer identity-related questions as needed
```

---

## 🚦 Quality Gates - Your Deliverables

### Gate 1: Identity Configuration Ready ✅
**Your Deliverables:**

Checklist before handoff to Security:
- [ ] App registration created with correct naming
- [ ] Authentication flows configured
- [ ] Redirect URIs properly set
- [ ] API permissions added (without consent)
- [ ] Service principal created
- [ ] User groups created (if required)
- [ ] All IDs documented in Azure DevOps
- [ ] Jira ticket updated with details
- [ ] Security Team notified

**Handoff Point**: Security Team takes over for approvals

---

## 🗓️ Your Daily Routine

### Morning (1 hour)
- Check Jira for new identity requests
- Review overnight automation jobs
- Respond to urgent requests in Teams

### Mid-Morning (2 hours)
- Process identity requests
- Create app registrations
- Configure authentication settings

### Afternoon (2 hours)
- Script maintenance and improvements
- Documentation updates
- Audit log reviews

### End of Day (30 minutes)
- Update Jira tickets with progress
- Prepare handoffs to Security Team
- Plan next day's work

---

## 💬 Common Scenarios & How to Handle

### Scenario 1: Urgent Production Issue
```
Situation: App can't authenticate, production down
Your Actions:
1. Check Azure Portal → Entra ID → Enterprise Apps
2. Verify app registration still exists
3. Check if credentials expired
4. Review recent changes in audit logs
5. Coordinate with Security Team if permissions issue
6. Create incident ticket in Jira
7. Post in Teams #incidents channel

Common Fixes:
- Client secret expired → Generate new secret
- Redirect URI mismatch → Add correct URI
- App disabled → Re-enable application
```

### Scenario 2: Security Rejects Permissions
```
Situation: Security Team rejects requested API permissions
Your Actions:
1. Schedule meeting with Security Team
2. Understand specific concerns
3. Work with Business Owner and Dev Team for alternatives
4. Update app registration with alternative permissions
5. Resubmit for Security review
6. Update Jira with resolution

Communication Template:
"Hi Security Team, I understand [permission] was rejected 
due to [reason]. After discussing with [teams], we propose 
using [alternative permission] which provides [explanation]. 
This addresses the security concern because [justification]. 
Can you review this alternative approach?"
```

### Scenario 3: Multi-Environment Setup
```
Situation: Need identical setup for Dev, Test, Prod
Your Actions:
1. Use parameterized PowerShell script
2. Run script for each environment:
   .\create-app-registration.ps1 -AppName "MyApp" -Environment "Dev"
   .\create-app-registration.ps1 -AppName "MyApp" -Environment "Test"
   .\create-app-registration.ps1 -AppName "MyApp" -Environment "Prod"
3. Document all three registrations
4. Ensure consistent configuration across environments
5. Note: Security approval needed for each!

Naming Convention:
- MyApp-Dev
- MyApp-Test
- MyApp-Prod
```

### Scenario 4: External Partner Integration
```
Situation: External partner needs to integrate with your API
Your Actions:
1. Confirm business approval from Product Owner
2. Create multi-tenant app registration OR
3. Create guest user accounts in your tenant
4. Configure appropriate API permissions
5. Work with Security Team for external access policies
6. Document partner organization details
7. Set up periodic access reviews

Extra Security Requirements:
- Conditional access policies
- MFA requirements
- Limited permission scope
- Regular access audits
```

---

## 📈 Success Metrics You Own

### Operational Metrics
- **Request fulfillment time**: <2 business days
- **Configuration accuracy**: >99% (minimal rework)
- **Automation coverage**: >80% of tasks scripted
- **Documentation quality**: Complete for 100% of apps

### Quality Metrics
- **Production authentication issues**: <1 per quarter
- **Security review pass rate**: >95% first-time
- **Credential expiry incidents**: Zero (proactive renewal)
- **Audit compliance**: 100% configurations logged

---

## 🤝 Key Relationships

### Teams You Work With Closely

#### Security Team (Daily)
- **Hybrid Model Partners**: You implement, they approve
- **What they need from you**: Properly configured app registrations, clear permission justifications
- **What you get from them**: Approval decisions, security requirements
- **Communication**: Jira tickets, Teams #identity-security channel
- **Handoff Point**: After you configure, before they approve

#### Development Team (Weekly)
- **What they need from you**: Application IDs, authentication guidance
- **What you get from them**: Requirements, integration questions
- **Communication**: Teams, technical consultations

#### Platform Team (As needed)
- **What they need from you**: Service principal details for Azure resources
- **What you get from them**: Resource requirements
- **Communication**: Azure DevOps, Teams

---

## 📚 Scripts Library

### Essential Scripts (Azure DevOps Repo)

#### 1. create-app-registration.ps1
```powershell
# Creates app registration with standard configuration
# Usage: .\create-app-registration.ps1 -AppName "MyApp" -Environment "Prod"
```

#### 2. add-api-permissions.ps1
```powershell
# Adds Microsoft Graph permissions
# Usage: .\add-api-permissions.ps1 -AppId "xxx" -Permissions @("User.Read","User.ReadBasic.All")
```

#### 3. create-user-groups.ps1
```powershell
# Creates Entra ID groups for app access
# Usage: .\create-user-groups.ps1 -GroupName "MyApp-Users-Prod"
```

#### 4. generate-client-secret.ps1
```powershell
# Generates new client secret with expiry tracking
# Usage: .\generate-client-secret.ps1 -AppId "xxx" -ValidityMonths 12
```

#### 5. audit-app-registrations.ps1
```powershell
# Audits all app registrations for compliance
# Usage: .\audit-app-registrations.ps1 -GenerateReport
```

**Script Location**: Azure DevOps → identity-scripts repository

---

## 🔒 Security Best Practices

### Never Do
- ❌ Grant admin consent (Security Team only)
- ❌ Share Application IDs in public channels
- ❌ Create overly broad permissions
- ❌ Skip documentation
- ❌ Use personal accounts for service principals

### Always Do
- ✅ Follow naming conventions
- ✅ Use managed identities when possible
- ✅ Set appropriate token lifetimes
- ✅ Document all configurations
- ✅ Enable audit logging
- ✅ Rotate secrets before expiry
- ✅ Use least-privilege permissions

---

## ❓ FAQ

**Q: What's the difference between app registration and service principal?**
A: App registration is the definition, service principal is the instance in your tenant.

**Q: When should I use managed identity vs. service principal?**
A: Use managed identity for Azure resources (preferred). Use service principal for external apps.

**Q: How long should client secrets be valid?**
A: Maximum 12 months. Set calendar reminder for renewal 30 days before expiry.

**Q: Can I delete an app registration?**
A: Only with approval. Check dependencies first. Soft delete allows 30-day recovery.

**Q: What if I accidentally grant admin consent?**
A: Immediately revoke it and notify Security Team. Document incident.

**Q: How do I handle emergency after-hours requests?**
A: Follow on-call procedure. Create app registration, notify Security Team for next-day approval.

---

## 🎯 Quick Wins - Your First 30 Days

### Week 1: Setup
- [ ] Get all tool access
- [ ] Clone identity-scripts repository
- [ ] Run test scripts in dev environment
- [ ] Review existing app registrations
- [ ] Shadow experienced team member

### Week 2: Learning
- [ ] Complete Entra ID training (Microsoft Learn)
- [ ] Review security standards document
- [ ] Practice creating app registrations
- [ ] Learn automation scripts

### Week 3: Assisted Work
- [ ] Handle requests with supervision
- [ ] Create first production app registration
- [ ] Update documentation
- [ ] Participate in security reviews

### Week 4: Independent Work
- [ ] Handle requests independently
- [ ] Improve automation scripts
- [ ] Contribute to team knowledge base

---

## 📞 Who to Contact

### Daily Questions
- **Identity Team Lead**: identity-lead@company.com
- **Teams Channel**: #identity-team
- **Response Time**: <2 hours

### Security Coordination
- **Security Team Lead**: security-lead@company.com
- **Teams Channel**: #identity-security
- **Response Time**: <4 hours

### Urgent Issues
- **On-Call Identity Engineer**: On-call rotation in Teams
- **Security On-Call**: security-oncall@company.com
- **Use for**: Production authentication failures

---

## ✅ Your Onboarding Checklist

- [ ] Read this entire deck
- [ ] Complete tool access requests
- [ ] Clone and review identity-scripts repo
- [ ] Complete Entra ID fundamentals training
- [ ] Shadow 3 app registration creations
- [ ] Create test app registration
- [ ] Meet Security Team counterparts
- [ ] Review past 10 Jira tickets
- [ ] Join all required Teams channels
- [ ] Bookmark Azure Portal Entra ID page

---

**Document Owner**: Identity Team Lead  
**Last Updated**: January 2025  
**Questions?** Post in Teams #identity-team channel  
**Feedback?** Contact identity-lead@company.com

---

*As part of the Identity Team, you enable secure authentication for all applications. Your technical expertise in Entra ID configuration is critical to the workflow's success.*
