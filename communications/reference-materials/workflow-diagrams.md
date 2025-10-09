# Workflow Diagrams - Azure E2E Production Workflow

Visual representations of the complete workflow, team interactions, and system architecture.

---

## Complete End-to-End Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     AZURE E2E PRODUCTION WORKFLOW                            │
│                    From Request to Production Deployment                     │
└─────────────────────────────────────────────────────────────────────────────┘

PHASE 1: REQUEST & PLANNING (Week 1)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│Business Owner│ Creates Jira Ticket
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Solution    │ Architecture Design
│  Architect   │ + Tech Stack Selection
└──────┬───────┘
       │
       ▼
    [Architecture Review Board]
       │ APPROVED
       ▼

PHASE 2: SECURITY & IDENTITY (Days 1-3)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐         ┌──────────────┐
│Identity Team │────────▶│Security Team │
└──────────────┘         └──────────────┘
       │                        │
       │ 1. Create App          │ 2. Review &
       │    Registration        │    Approve
       │ 2. Configure           │ 3. Grant Admin
       │    Authentication      │    Consent
       │ 3. Add Permissions     │ 4. Configure CA
       │                        │    Policies
       ▼                        ▼
    [Identity Ready]      [Security Approved]
       │                        │
       └────────┬───────────────┘
                ▼

PHASE 2A: API GOVERNANCE (Days 2-4)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│ API          │ 1. Register API in API Center
│ Governance   │ 2. Add Compliance Metadata
│ Team         │ 3. Review Against Standards
└──────┬───────┘ 4. Approve for Development
       │
       ▼
    [API Registered & Approved]
       │
       ▼

PHASE 3: INFRASTRUCTURE (Days 3-5)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│  Platform    │ 1. Create Terraform Configs
│  Team        │ 2. Run Azure DevOps Pipeline
└──────┬───────┘ 3. Provision Resources
       │         4. Configure Networking
       │         5. Setup Key Vault
       ▼
    [Infrastructure Ready]
    - Resource Group
    - App Service
    - Key Vault
    - Container Registry
    - Managed Identity
       │
       ▼

PHASE 4: DEVELOPMENT (Days 5-10)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│  Dev Team    │ 1. Implement Entra ID Auth
└──────┬───────┘ 2. Integrate Key Vault
       │         3. Write Application Code
       │         4. Create Docker Container
       │         5. Unit & Integration Tests
       │         6. Code Review & Merge
       ▼
    [Application Ready]
       │
       ▼

PHASE 5: DEPLOYMENT (Days 10-12)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│  DevOps      │ 1. CI/CD Pipeline Execution
│  Team        │ 2. Build Docker Image
└──────┬───────┘ 3. Push to Container Registry
       │         4. Deploy to Staging
       │         5. Run Automated Tests
       │         6. Deploy to Production
       ▼
    [Application Deployed]
       │
       ▼

PHASE 6: API MANAGEMENT (Days 12-13)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│  API Team    │ 1. Import API to APIM
└──────┬───────┘ 2. Configure Policies
       │         3. Set Rate Limits
       │         4. Enable JWT Validation
       │         5. Test & Publish
       ▼
    [API Ready for Consumption]
       │
       ▼

PHASE 6B: DEVELOPER EXPERIENCE (Days 13-14)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│  Developer   │ 1. Customize Portal
│  Relations   │ 2. Create Documentation
└──────┬───────┘ 3. Configure Subscriptions
       │         4. Publish to Portal
       ▼
    [Developer Portal Live]
       │
       ▼

PHASE 7: MONITORING & OPERATIONS (Ongoing)
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐
│  Operations  │ 1. Configure App Insights
│  Team        │ 2. Create Dashboards
└──────┬───────┘ 3. Set Up Alerts
       │         4. Monitor Health
       │         5. Respond to Incidents
       ▼
    [Production Monitoring Active]
       │
       ▼
    ✅ APPLICATION LIVE IN PRODUCTION
```

---

## Team Interaction Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          TEAM INTERACTION MAP                                │
└─────────────────────────────────────────────────────────────────────────────┘

Business Layer
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────────┐
    │  Business    │
    │  Owner       │
    └──────┬───────┘
           │ Requirements
           ▼
    ┌──────────────┐
    │  Solution    │
    │  Architect   │
    └──────┬───────┘
           │ Architecture
           │
           ├─────────────────────────────────────┐
           │                                     │
           ▼                                     ▼

Security & Identity Layer (Hybrid Model)
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────────┐         ┌──────────────┐
    │  Identity    │◀───────▶│  Security    │
    │  Team        │  Hybrid │  Team        │
    └──────┬───────┘  Model  └──────┬───────┘
           │                        │
           │ Identity Config        │ Approval
           │                        │
           └───────────┬────────────┘
                       │
                       ▼

Governance Layer
═══════════════════════════════════════════════════════════════════════════════
                ┌──────────────┐
                │  API         │
                │  Governance  │
                └──────┬───────┘
                       │ API Standards
                       │
                       ├─────────────────┐
                       │                 │
                       ▼                 ▼

Infrastructure & Development Layer
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────────┐         ┌──────────────┐
    │  Platform    │────────▶│  Dev Team    │
    │  Team        │  Infra  └──────┬───────┘
    └──────┬───────┘                │
           │                        │ Code
           │ IaC                    │
           │                        ▼
           │                 ┌──────────────┐
           │                 │  DevOps      │
           │                 │  Team        │
           │                 └──────┬───────┘
           │                        │ Deploy
           │                        │
           └────────┬───────────────┘
                    │
                    ▼

API & Experience Layer
═══════════════════════════════════════════════════════════════════════════════
             ┌──────────────┐         ┌──────────────┐
             │  API Team    │────────▶│  Developer   │
             └──────┬───────┘  Portal │  Relations   │
                    │                 └──────────────┘
                    │ APIM Config
                    │
                    ▼

Operations Layer
═══════════════════════════════════════════════════════════════════════════════
             ┌──────────────┐
             │  Operations  │
             │  Team        │
             └──────────────┘
                    │
                    │ Monitors All
                    ▼
    ┌─────────────────────────────────┐
    │   ALL PRODUCTION SYSTEMS        │
    └─────────────────────────────────┘
```

---

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AZURE ARCHITECTURE                                   │
└─────────────────────────────────────────────────────────────────────────────┘

External Access
═══════════════════════════════════════════════════════════════════════════════
                    ┌──────────────┐
                    │  External    │
                    │  Developer   │
                    └──────┬───────┘
                           │ HTTPS
                           ▼
                    ┌──────────────┐
                    │  Developer   │
                    │  Portal      │
                    └──────┬───────┘
                           │
                           ▼

API Gateway Layer
═══════════════════════════════════════════════════════════════════════════════
                    ┌──────────────────────────────┐
                    │   Azure API Management       │
                    │  ┌────────────────────────┐  │
                    │  │ Rate Limiting          │  │
                    │  │ JWT Validation         │  │
                    │  │ Policy Enforcement     │  │
                    │  │ Analytics              │  │
                    │  └────────────────────────┘  │
                    └──────────┬───────────────────┘
                               │
                               ▼

Application Layer
═══════════════════════════════════════════════════════════════════════════════
        ┌────────────────────────────────────────────┐
        │           Azure App Service                 │
        │  ┌──────────────────────────────────────┐  │
        │  │  Docker Container                     │  │
        │  │  ┌────────────────────────────────┐  │  │
        │  │  │  Your Application              │  │  │
        │  │  │  - .NET 8 API                  │  │  │
        │  │  │  - Entra ID Integration       │  │  │
        │  │  │  - Key Vault SDK              │  │  │
        │  │  └────────────────────────────────┘  │  │
        │  └──────────────────────────────────────┘  │
        └──────┬──────────────────────┬───────────────┘
               │                      │
               │                      │
               ▼                      ▼

Identity & Security Layer
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────────┐           ┌──────────────┐
    │   Entra ID   │           │  Key Vault   │
    │              │           │              │
    │ - App Reg    │           │ - Secrets    │
    │ - Users      │           │ - Certs      │
    │ - Groups     │           │ - Keys       │
    │ - CA Policies│           │              │
    └──────┬───────┘           └──────┬───────┘
           │                          │
           │ Auth                     │ Secrets
           │                          │
           └─────────┬────────────────┘
                     │
                     │ Managed Identity
                     ▼

Data & Storage Layer
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────────┐           ┌──────────────┐
    │  Azure SQL   │           │  Blob        │
    │  Database    │           │  Storage     │
    └──────────────┘           └──────────────┘

Container Management
═══════════════════════════════════════════════════════════════════════════════
              ┌──────────────────┐
              │  Container       │
              │  Registry (ACR)  │
              └──────────────────┘

Monitoring & Governance
═══════════════════════════════════════════════════════════════════════════════
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Application  │  │ Log          │  │ Azure        │  │ API Center   │
│ Insights     │  │ Analytics    │  │ Monitor      │  │ (Governance) │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
        │                 │                 │                 │
        └─────────────────┴─────────────────┴─────────────────┘
                              │
                              ▼
                    ┌──────────────┐
                    │  Operations  │
                    │  Dashboard   │
                    └──────────────┘
```

---

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      REQUEST/RESPONSE FLOW                                   │
└─────────────────────────────────────────────────────────────────────────────┘

Step 1: User Authentication
═══════════════════════════════════════════════════════════════════════════════
    User
     │
     │ 1. Access application
     ▼
    APIM
     │
     │ 2. Redirect to Entra ID
     ▼
    Entra ID
     │
     │ 3. MFA Challenge (if CA policy applies)
     │ 4. Issue JWT token
     ▼
    User (with JWT)

Step 2: API Request
═══════════════════════════════════════════════════════════════════════════════
    User (with JWT)
     │
     │ GET /api/users
     │ Authorization: Bearer <JWT>
     │ Ocp-Apim-Subscription-Key: <KEY>
     ▼
    ┌─────────────────────────────────┐
    │  Azure API Management (APIM)    │
    │                                  │
    │  ✓ Validate JWT                 │
    │  ✓ Check rate limit             │
    │  ✓ Check subscription           │
    │  ✓ Apply policies               │
    └──────────┬──────────────────────┘
               │
               │ Forward request
               ▼
    ┌─────────────────────────────────┐
    │  App Service                     │
    │                                  │
    │  ✓ Additional auth check        │
    │  ✓ Business logic               │
    │  ✓ Query database               │
    └──────────┬──────────────────────┘
               │
               │ Need secrets?
               ▼
    ┌─────────────────────────────────┐
    │  Key Vault                       │
    │                                  │
    │  ← Managed Identity              │
    │  → Return secrets                │
    └──────────┬──────────────────────┘
               │
               │ Execute query
               ▼
    ┌─────────────────────────────────┐
    │  Azure SQL Database              │
    │                                  │
    │  ← Connection string             │
    │  → Return data                   │
    └──────────┬──────────────────────┘
               │
               │ Format response
               ▼
    App Service
     │
     │ Return JSON
     ▼
    APIM
     │
     │ Add headers
     │ Log metrics
     ▼
    User

Step 3: Telemetry & Monitoring
═══════════════════════════════════════════════════════════════════════════════
    ┌─────────────────────────────────┐
    │  Application Insights            │
    │                                  │
    │  ← Request telemetry             │
    │  ← Performance metrics           │
    │  ← Exception data                │
    └──────────┬──────────────────────┘
               │
               ▼
    ┌─────────────────────────────────┐
    │  Log Analytics                   │
    │                                  │
    │  → Store logs                    │
    │  → Query interface               │
    └──────────┬──────────────────────┘
               │
               ▼
    ┌─────────────────────────────────┐
    │  Azure Monitor                   │
    │                                  │
    │  → Alerts                        │
    │  → Dashboards                    │
    └──────────┬──────────────────────┘
               │
               ▼
    Operations Team
```

---

## CI/CD Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       CI/CD PIPELINE FLOW                                    │
└─────────────────────────────────────────────────────────────────────────────┘

Continuous Integration (CI)
═══════════════════════════════════════════════════════════════════════════════
    Developer
       │
       │ git push
       ▼
    Azure DevOps Git
       │
       │ Trigger
       ▼
    ┌──────────────────────────────────┐
    │  Build Pipeline                   │
    │                                   │
    │  1. Restore dependencies          │
    │  2. Build code                    │
    │  3. Run unit tests               │
    │  4. Run security scan            │
    │  5. Build Docker image           │
    │  6. Push to ACR                  │
    │  7. Publish artifacts            │
    └──────────┬───────────────────────┘
               │
               │ Build #1234
               ▼
    ┌──────────────────────────────────┐
    │  Container Registry (ACR)         │
    │                                   │
    │  myapp:1234                      │
    │  myapp:latest                    │
    └──────────┬───────────────────────┘
               │
               │ Trigger
               ▼

Continuous Deployment (CD)
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────────────────────────────┐
    │  Release Pipeline                 │
    │                                   │
    │  Stage 1: Deploy to Staging      │
    │  ├─ Pull image from ACR          │
    │  ├─ Deploy to staging slot       │
    │  ├─ Run smoke tests              │
    │  └─ Health check                 │
    └──────────┬───────────────────────┘
               │
               │ ✓ Tests passed
               ▼
    ┌──────────────────────────────────┐
    │  Approval Gate                    │
    │                                   │
    │  Manual approval required        │
    │  by DevOps Lead                  │
    └──────────┬───────────────────────┘
               │
               │ ✓ Approved
               ▼
    ┌──────────────────────────────────┐
    │  Stage 2: Deploy to Production   │
    │                                   │
    │  ├─ Swap slots                   │
    │  ├─ Warm up new slot             │
    │  ├─ Verify health                │
    │  └─ Complete swap                │
    └──────────┬───────────────────────┘
               │
               │ ✓ Deployed
               ▼
    ┌──────────────────────────────────┐
    │  Production Monitoring            │
    │                                   │
    │  ← Application Insights           │
    │  ← Azure Monitor alerts           │
    │  → Operations dashboard           │
    └───────────────────────────────────┘

Rollback (if needed)
═══════════════════════════════════════════════════════════════════════════════
    Issue Detected
       │
       │ Trigger rollback
       ▼
    ┌──────────────────────────────────┐
    │  Rollback Pipeline                │
    │                                   │
    │  1. Swap back to previous slot   │
    │  2. Verify health                │
    │  3. Notify team                  │
    └──────────┬───────────────────────┘
               │
               │ <5 minutes
               ▼
    Previous version restored
```

---

## Quality Gates Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         QUALITY GATES FLOW                                   │
└─────────────────────────────────────────────────────────────────────────────┘

    START
      │
      ▼
┌─────────────────────┐
│ GATE 1: Requirements│
│ Complete            │
│                     │
│ Owner: Business     │
│ Check: Requirements │
│        documented   │
└─────┬───────────────┘
      │ ✅ PASS
      ▼
┌─────────────────────┐
│ GATE 2: Architecture│
│ Approved            │
│                     │
│ Owner: Architect    │
│ Check: Design       │
│        reviewed     │
└─────┬───────────────┘
      │ ✅ PASS
      ▼
┌─────────────────────┐
│ GATE 3: Security    │
│ Approved            │
│                     │
│ Owner: Security     │
│ Check: Permissions  │
│        approved     │
└─────┬───────────────┘
      │ ✅ PASS
      ▼
┌─────────────────────┐
│ GATE 4: Infra Ready │
│                     │
│ Owner: Platform     │
│ Check: Resources    │
│        provisioned  │
└─────┬───────────────┘
      │ ✅ PASS
      ▼
┌─────────────────────┐
│ GATE 5: App Deployed│
│                     │
│ Owner: DevOps       │
│ Check: Health       │
│        verified     │
└─────┬───────────────┘
      │ ✅ PASS
      ▼
┌─────────────────────┐
│ GATE 6: API Ready   │
│                     │
│ Owner: API Team     │
│ Check: APIM         │
│        configured   │
└─────┬───────────────┘
      │ ✅ PASS
      ▼
┌─────────────────────┐
│ GATE 7: Production  │
│ Go-Live             │
│                     │
│ Owner: Business     │
│ Check: UAT complete │
└─────┬───────────────┘
      │ ✅ PASS
      ▼
   PRODUCTION
```

---

## Incident Response Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      INCIDENT RESPONSE FLOW                                  │
└─────────────────────────────────────────────────────────────────────────────┘

Detection
═══════════════════════════════════════════════════════════════════════════════
    Application Insights
           │
           │ Alert triggered
           ▼
    Azure Monitor
           │
           │ Severity: HIGH
           │ HTTP 5xx > threshold
           ▼
    ┌──────────────────┐
    │  Notifications   │
    │  - Teams         │
    │  - Email         │
    │  - Jira ticket   │
    └─────┬────────────┘
          │
          ▼

Response
═══════════════════════════════════════════════════════════════════════════════
    On-Call Engineer
           │
           │ 1. Acknowledge
           ▼
    Review Dashboard
           │
           │ 2. Assess impact
           │    - Users affected?
           │    - Data loss?
           │    - Security breach?
           ▼
    ┌──────────────────┐
    │  Severity Level  │
    │  - P1: Critical  │
    │  - P2: High      │
    │  - P3: Medium    │
    └─────┬────────────┘
          │
          ▼

Resolution (P1 Critical Example)
═══════════════════════════════════════════════════════════════════════════════
    Incident Commander (On-Call)
           │
           │ 3. Assemble war room
           ▼
    ┌────────────────────────────┐
    │  War Room (Teams call)     │
    │  - On-Call Engineer        │
    │  - DevOps Team             │
    │  - Dev Team                │
    │  - Platform Team           │
    └─────┬──────────────────────┘
          │
          │ 4. Investigate
          │    - Review logs
          │    - Check recent changes
          │    - Identify root cause
          ▼
    Root Cause Identified
          │
          │ 5. Fix
          │    Option A: Rollback
          │    Option B: Hotfix
          ▼
    ┌──────────────────┐
    │  Implement Fix   │
    └─────┬────────────┘
          │
          │ 6. Verify
          ▼
    ┌──────────────────┐
    │  Health Check    │
    │  ✓ Errors cleared│
    │  ✓ Metrics normal│
    └─────┬────────────┘
          │
          │ 7. Close incident
          ▼

Post-Incident
═══════════════════════════════════════════════════════════════════════════════
    ┌──────────────────┐
    │  Post-Mortem     │
    │  - What happened │
    │  - Why happened  │
    │  - How to prevent│
    └─────┬────────────┘
          │
          │ 8. Document
          ▼
    ┌──────────────────┐
    │  Action Items    │
    │  - Fix root cause│
    │  - Improve alerts│
    │  - Update runbook│
    └──────────────────┘
```

---

## Approval Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           APPROVAL FLOW                                      │
└─────────────────────────────────────────────────────────────────────────────┘

    Request Submitted
           │
           ▼
    ┌──────────────────┐
    │  Business Review │
    │  (1-2 days)      │
    └─────┬────────────┘
          │
          ├─── Approved ──────┐
          │                   │
          └─── Rejected       │
                 │            │
                 ▼            ▼
              Request     Architecture
               Ends          Review
                                │
                                ├─── Approved ──────┐
                                │                   │
                                └─── Needs Changes  │
                                       │            │
                                       ▼            ▼
                                    Revise      Security
                                                 Review
                                                    │
                                                    ├─── Approved ──────┐
                                                    │                   │
                                                    └─── Rejected       │
                                                           │            │
                                                           ▼            ▼
                                                        Revise      Proceed to
                                                                   Implementation
```

---

**Document Owner**: PMO Team  
**Last Updated**: January 2025  
**Format**: Markdown with ASCII diagrams  
**Usage**: Reference for training, presentations, and onboarding

---

*These diagrams provide visual clarity on the Azure E2E Production Workflow processes, helping teams understand their role and interactions.*
