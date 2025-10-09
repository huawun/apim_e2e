# Quick Reference Cards - Azure E2E Workflow

One-page summaries for each team in the workflow.

---

## Business/Product Owner - Quick Reference

**Your Mission**: Initiate and champion application requests

**Key Actions**:
1. Create Jira ticket with business case
2. Present at architecture review board
3. Approve requirements and go-live

**Tools**: Jira, Teams, SharePoint, PowerPoint

**Success**: Clear requirements → Fast approval → Business value delivered

**Contact**: PMO Team (pmo@company.com)

---

## Solution Architect - Quick Reference

**Your Mission**: Design technical architecture and guide implementation

**Key Actions**:
1. Create architecture diagrams
2. Select technology stack
3. Present to architecture review board
4. Create Azure DevOps Epic

**Tools**: Visio/Draw.io, Azure DevOps, Azure Portal

**Success**: Approved architecture → Scalable design → No rework

**Contact**: Architecture Lead (arch-lead@company.com)

---

## Identity Team - Quick Reference

**Your Mission**: Technical Entra ID implementation

**Key Actions**:
1. Create app registration
2. Configure authentication flows
3. Add API permissions (no consent)
4. Create user groups
5. Handoff to Security Team

**Tools**: Azure Portal, PowerShell, Azure DevOps

**Success**: Configured in 2 days → Zero auth issues

**Contact**: Identity Team Lead (identity-lead@company.com)

---

## Security Team - Quick Reference

**Your Mission**: Approve permissions and enforce security policies

**Key Actions**:
1. Review API permissions
2. Approve/reject based on risk
3. Grant admin consent
4. Configure conditional access policies

**Tools**: Azure Portal, Security Center, Jira

**Success**: Reviewed in 1 day → Zero security incidents

**Contact**: Security Team Lead (security-lead@company.com)

---

## API Governance Team - Quick Reference

**Your Mission**: Manage API standards and lifecycle

**Key Actions**:
1. Register API in API Center
2. Add compliance metadata
3. Review against standards
4. Track through lifecycle

**Tools**: Azure API Center, PowerShell, Jira

**Success**: 100% APIs registered → Compliance maintained

**Contact**: API Governance (api-governance@company.com)

---

## Platform/Infrastructure Team - Quick Reference

**Your Mission**: Provision Azure infrastructure via IaC

**Key Actions**:
1. Create/update Terraform configs
2. Run pipeline for provisioning
3. Verify in Azure Portal
4. Document resource IDs

**Tools**: Terraform, Azure DevOps Pipelines, Azure Portal

**Success**: Provisioned in 1 day → 100% via IaC

**Contact**: Platform Team (platform-team@company.com)

---

## Development Team - Quick Reference

**Your Mission**: Build applications with Azure integrations

**Key Actions**:
1. Implement Entra ID authentication
2. Integrate Key Vault SDK
3. Create Docker container
4. Write tests and submit PR

**Tools**: VS Code, Docker, Git, Postman

**Success**: Feature in 3 days → >90% code coverage

**Contact**: Dev Team (dev-team@company.com)

---

## DevOps Engineering Team - Quick Reference

**Your Mission**: Automate CI/CD pipelines

**Key Actions**:
1. Create build pipeline
2. Create release pipeline
3. Configure deployment slots
4. Execute and monitor deployment

**Tools**: Azure DevOps Pipelines, Azure Container Registry

**Success**: Deploy in 30 min → >95% success rate

**Contact**: DevOps Team (devops-team@company.com)

---

## API Management Team - Quick Reference

**Your Mission**: Configure APIM for security and routing

**Key Actions**:
1. Import API definition
2. Apply security policies (JWT)
3. Set rate limits
4. Test and publish

**Tools**: Azure APIM Portal, Postman, OpenAPI/Swagger

**Success**: Configured in 1 day → 100% secured

**Contact**: API Team (api-team@company.com)

---

## Developer Relations Team - Quick Reference

**Your Mission**: Manage Developer Portal experience

**Key Actions**:
1. Customize portal branding
2. Create documentation
3. Configure subscription plans
4. Support developers

**Tools**: Azure API Developer Portal, Markdown

**Success**: Portal in 1 week → >50 developers/month

**Contact**: Dev Relations (dev-relations@company.com)

---

## Operations/Monitoring Team - Quick Reference

**Your Mission**: Monitor health and handle incidents

**Key Actions**:
1. Configure Application Insights
2. Create dashboards
3. Set up alerts
4. Respond to incidents

**Tools**: Application Insights, Azure Monitor, Jira

**Success**: >99.9% uptime → <5 min detection time

**Contact**: Operations Team (operations-team@company.com)

---

# Emergency Contacts

| Situation | Contact | Channel |
|-----------|---------|---------|
| **Production Down** | On-Call Engineer | Teams #incidents |
| **Security Incident** | Security On-Call | security-oncall@company.com |
| **Process Question** | PMO Team | pmo@company.com |
| **Approval Stuck** | Team Lead | Direct Teams message |

---

# Common Workflows

## New Application Request
1. Business Owner → Jira ticket
2. Solution Architect → Design
3. Identity Team → Create app registration
4. Security Team → Approve permissions
5. Platform Team → Provision infrastructure
6. Dev Team → Build application
7. DevOps Team → Deploy
8. API Team → Configure APIM
9. Developer Relations → Publish documentation
10. Operations → Monitor

**Timeline**: 1-2 weeks for standard apps

## Permission Change Request
1. Identity Team → Update app registration
2. Security Team → Review and approve
3. Identity Team → Notify Dev Team

**Timeline**: 1-2 days

## Production Incident
1. Operations → Detect via alerts
2. Operations → Create Jira incident
3. On-Call Engineer → Investigate
4. Dev/DevOps Team → Fix and deploy
5. Operations → Verify resolution

**Timeline**: <1 hour for critical issues

---

# Key Metrics Summary

| Team | Primary Metric | Target |
|------|---------------|--------|
| Business Owner | Time to approval | <3 days |
| Solution Architect | Time to architecture approval | <1 week |
| Identity Team | Request fulfillment | <2 days |
| Security Team | Review turnaround | <1 day |
| API Governance | API registration | <2 days |
| Platform Team | Infrastructure provisioning | <1 day |
| Development Team | Feature implementation | <3 days |
| DevOps Team | Deployment time | <30 min |
| API Management Team | APIM configuration | <1 day |
| Developer Relations | Portal setup | <1 week |
| Operations Team | Uptime | >99.9% |

---

# Phase Ownership

| Phase | Primary Owner | Support Teams |
|-------|--------------|---------------|
| Phase 1: Planning | Business Owner | Solution Architect |
| Phase 2: Identity | Identity Team | Security Team |
| Phase 2A: API Governance | API Governance | Solution Architect |
| Phase 3: Infrastructure | Platform Team | Solution Architect |
| Phase 4: Development | Dev Team | Solution Architect |
| Phase 5: Deployment | DevOps Team | Platform Team |
| Phase 6: API Management | API Team | API Governance |
| Phase 6B: Developer Experience | Developer Relations | API Team |
| Phase 7: Operations | Operations Team | All Teams |

---

# Tool Access Checklist

**Everyone Needs**:
- [ ] Jira account
- [ ] Microsoft Teams
- [ ] Azure Portal (read access minimum)

**By Role**:
- **Business Owner**: SharePoint, PowerPoint
- **Architect**: Visio/Draw.io, Azure DevOps
- **Identity**: Entra ID Admin, PowerShell
- **Security**: Security Admin, Conditional Access Admin
- **API Governance**: API Center access
- **Platform**: Terraform, Azure DevOps Pipelines
- **Development**: VS Code, Docker, Git
- **DevOps**: Azure DevOps Pipelines, Container Registry
- **API Team**: APIM Portal
- **Developer Relations**: Developer Portal Admin
- **Operations**: Application Insights, Log Analytics

---

# Training Resources

| Topic | Platform | Duration |
|-------|----------|----------|
| Jira Basics | Company LMS | 30 min |
| Azure Fundamentals | Microsoft Learn | 2 hours |
| Entra ID Administration | Microsoft Learn | 4 hours |
| Azure Security | Microsoft Learn | 3 hours |
| Terraform Basics | HashiCorp Learn | 2 hours |
| Azure DevOps Pipelines | Microsoft Learn | 3 hours |
| Docker Fundamentals | Docker Docs | 2 hours |
| API Management | Microsoft Learn | 2 hours |

---

**Print These Cards**: Cut along lines and laminate for desk reference

**Digital Version**: Bookmark this page in your browser

**Questions?** Contact PMO Team (pmo@company.com)

---

*Last Updated: January 2025*
