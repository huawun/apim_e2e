# RACI Matrix - Azure E2E Workflow

**Legend:**
- **R** = Responsible (Does the work)
- **A** = Accountable (Decision maker, ultimately answerable)
- **C** = Consulted (Provides input, two-way communication)
- **I** = Informed (Kept updated, one-way communication)

---

## Phase 1: REQUEST & PLANNING

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Create business case | R/A | C | I | I | I | I | I | I | I | I | I |
| Submit Jira request | R/A | I | I | I | I | I | I | I | I | I | I |
| Architecture design | C | R/A | I | C | C | C | I | I | I | I | I |
| Present to review board | R | R/A | I | C | C | I | I | I | I | I | I |
| Create Azure DevOps Epic | C | R/A | I | I | I | I | I | I | I | I | I |
| Approve requirements | R/A | C | I | I | I | I | I | I | I | I | I |

---

## Phase 2: SECURITY & IDENTITY

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Create app registration | I | C | R/A | I | I | I | I | I | I | I | I |
| Configure authentication | I | C | R/A | C | I | I | I | I | I | I | I |
| Add API permissions | I | I | R | C | I | I | I | I | I | I | I |
| Review permissions | I | I | I | R/A | I | I | I | I | I | I | I |
| Approve/reject permissions | I | I | I | R/A | I | I | I | I | I | I | I |
| Grant admin consent | I | I | I | R/A | I | I | I | I | I | I | I |
| Configure conditional access | I | C | C | R/A | I | I | I | I | I | I | I |
| Create user groups | I | I | R/A | I | I | I | I | I | I | I | I |
| Document configuration | I | I | R | C | I | I | I | I | I | I | I |

---

## Phase 2A: API DESIGN & GOVERNANCE

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Register API in API Center | I | C | I | I | R/A | I | C | I | I | I | I |
| Add compliance metadata | I | C | I | I | R/A | I | I | I | I | I | I |
| Review API design | I | C | I | I | R/A | I | C | I | I | I | I |
| Validate standards | I | C | I | I | R/A | I | C | I | I | I | I |
| Approve for development | I | I | I | I | R/A | I | I | I | I | I | I |
| Track lifecycle stages | I | I | I | I | R/A | I | I | I | C | I | I |

---

## Phase 3: INFRASTRUCTURE

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Create Terraform configs | I | C | I | I | I | R/A | C | C | I | I | I |
| Review IaC templates | I | C | I | C | I | R | C | C | I | I | I |
| Provision Azure resources | I | I | I | I | I | R/A | I | C | I | I | I |
| Configure networking | I | C | I | C | I | R/A | I | C | I | I | C |
| Setup Key Vault | I | I | C | C | I | R/A | C | I | I | I | I |
| Configure managed identities | I | I | C | C | I | R/A | C | I | I | I | I |
| Document resource IDs | I | I | I | I | I | R/A | I | C | I | I | I |
| Verify deployment | I | C | I | I | I | R/A | I | C | I | I | C |

---

## Phase 4: DEVELOPMENT

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Setup dev environment | I | I | I | I | I | C | R/A | I | I | I | I |
| Implement Entra ID auth | I | C | C | I | I | I | R/A | I | I | I | I |
| Integrate Key Vault | I | C | I | I | I | C | R/A | I | I | I | I |
| Write application code | C | C | I | I | I | I | R/A | I | I | I | I |
| Create unit tests | I | C | I | I | I | I | R/A | I | I | I | I |
| Build Docker container | I | I | I | I | I | I | R/A | C | I | I | I |
| Local testing | I | I | I | I | I | I | R/A | C | I | I | I |
| Code review | I | C | I | I | I | I | R/A | C | I | I | I |
| Merge to main branch | I | C | I | I | I | I | R/A | I | I | I | I |

---

## Phase 5: DEPLOYMENT

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Create build pipeline | I | C | I | I | I | C | C | R/A | I | I | I |
| Create release pipeline | I | C | I | I | I | C | C | R/A | I | I | C |
| Configure deployment slots | I | I | I | I | I | C | I | R/A | I | I | C |
| Build Docker image | I | I | I | I | I | I | C | R/A | I | I | I |
| Push to Container Registry | I | I | I | I | I | I | C | R/A | I | I | I |
| Deploy to staging | I | I | I | I | I | C | C | R/A | I | I | C |
| Run automated tests | I | I | I | I | I | I | C | R/A | I | I | C |
| Deploy to production | I | C | I | I | I | C | C | R/A | I | I | C |
| Verify health endpoint | I | I | I | I | I | I | C | R/A | I | I | C |
| Update documentation | I | I | I | I | I | I | C | R/A | I | I | I |

---

## Phase 6: API MANAGEMENT

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Import API definition | I | C | I | I | C | I | C | I | R/A | I | I |
| Configure backend URL | I | I | I | I | I | I | C | I | R/A | I | I |
| Apply security policies | I | C | I | C | I | I | C | I | R/A | I | I |
| Configure JWT validation | I | I | C | C | I | I | C | I | R/A | I | I |
| Set rate limits | I | C | I | I | C | I | C | I | R/A | I | C |
| Configure CORS | I | I | I | I | I | I | C | I | R/A | I | I |
| Test with Postman | I | I | I | I | I | I | C | I | R/A | C | I |
| Update lifecycle in API Center | I | I | I | I | C | I | I | I | R | I | I |
| Publish to APIM | I | I | I | I | C | I | I | I | R/A | C | I |

---

## Phase 6B: DEVELOPER EXPERIENCE

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Customize portal branding | C | I | I | I | I | I | I | I | C | R/A | I |
| Create getting started guide | I | C | I | I | C | I | C | I | C | R/A | I |
| Add code samples | I | I | I | I | I | I | C | I | C | R/A | I |
| Configure subscription plans | I | I | I | I | I | I | I | I | C | R/A | I |
| Enable self-service registration | I | I | I | C | I | I | I | I | C | R/A | I |
| Create API documentation | I | C | I | I | C | I | C | I | C | R/A | I |
| Monitor developer sign-ups | I | I | I | I | I | I | I | I | I | R/A | I |
| Respond to developer questions | I | I | I | I | I | I | C | I | C | R/A | I |
| Update documentation | I | C | I | I | I | I | C | I | C | R/A | I |

---

## Phase 7: MONITORING & OPERATIONS

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Configure Application Insights | I | C | I | I | I | C | C | C | I | I | R/A |
| Create dashboards | I | C | I | I | I | I | C | C | C | I | R/A |
| Set up alerts | I | C | I | I | I | C | C | C | C | I | R/A |
| Daily health checks | I | I | I | I | I | I | I | I | I | I | R/A |
| Monitor performance | I | C | I | I | I | I | C | C | C | I | R/A |
| Respond to incidents | I | C | I | I | I | C | C | C | C | I | R/A |
| Investigate issues | I | C | I | I | I | C | C | C | C | I | R/A |
| Performance optimization | I | C | I | I | I | C | C | C | C | I | R/A |
| Weekly reporting | C | C | I | I | I | I | I | I | I | I | R/A |
| Capacity planning | C | C | I | I | I | C | I | C | I | I | R/A |

---

## Cross-Cutting Activities

| Activity | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Jira ticket management | R/A | C | C | C | C | C | C | C | C | C | C |
| Teams communication | R | R | R | R | R | R | R | R | R | R | R |
| Documentation updates | C | C | R | R | R | R | R | R | R | R | R |
| Security audits | I | C | C | R/A | C | C | I | I | C | I | C |
| Compliance reviews | R | C | C | C | R/A | I | I | I | C | I | I |
| Architecture reviews | C | R/A | C | C | C | C | C | C | C | I | I |
| Incident response | I | C | C | C | I | C | C | C | C | I | R/A |
| Change management | R | C | C | C | C | C | C | R | C | I | C |

---

## Quality Gates Approval

| Quality Gate | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|--------------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| **Gate 1: Requirements Complete** | A | C | I | I | I | I | I | I | I | I | I |
| **Gate 2: Architecture Approved** | I | A | I | C | C | I | I | I | I | I | I |
| **Gate 3: Security Approved** | I | I | R | A | I | I | I | I | I | I | I |
| **Gate 4: Infrastructure Ready** | I | C | I | C | I | A | I | C | I | I | C |
| **Gate 5: Application Deployed** | I | C | I | I | I | C | C | A | I | I | C |
| **Gate 6: API Ready** | I | C | I | I | C | I | C | C | A | C | C |
| **Gate 7: Production Go-Live** | A | C | I | C | I | C | C | C | C | C | C |

---

## Decision Rights

| Decision | Business Owner | Solution Architect | Identity | Security | API Gov | Platform | Dev | DevOps | API | DevRel | Ops |
|----------|---------------|-------------------|----------|----------|---------|----------|-----|--------|-----|--------|-----|
| Business requirements approval | A | C | | | | | | | | | |
| Architecture approval | C | A | | C | C | | | | | | |
| API permission approval | | | | A | | | | | | | |
| Admin consent grant | | | | A | | | | | | | |
| Infrastructure design | | C | | C | | A | | | | | |
| Technology stack selection | C | A | | | | C | C | | | | |
| Deployment approval | | C | | | | | C | A | | | |
| Go-live approval | A | C | | C | | | | C | | | C |
| Security exception | | | | A | | | | | | | |
| Incident escalation | | C | | C | | C | C | C | | | A |

---

## Escalation Matrix

| Issue Type | Level 1 | Level 2 | Level 3 | Level 4 |
|------------|---------|---------|---------|---------|
| **Process/Workflow** | Team Lead | PMO Manager | Director | VP/CTO |
| **Technical** | Senior Engineer | Team Lead | Architect Lead | CTO |
| **Security** | Security Engineer | Security Lead | Security Director | CISO |
| **Business** | Product Owner | Business Manager | Director | Executive Sponsor |

---

## Notes on Usage

### How to Read This Matrix
- **Each row** represents an activity in the workflow
- **Each column** represents a team/role
- **Letters (R/A/C/I)** indicate the level of involvement

### Best Practices
1. **Only ONE Accountable (A)** per activity - ensures clear decision-making
2. **At least ONE Responsible (R)** per activity - ensures work gets done
3. **Consult (C) before** major decisions - ensures input from stakeholders
4. **Inform (I) after** decisions - ensures transparency

### Common Patterns
- **R/A together**: Person both does the work AND is ultimately accountable
- **R without A**: Team member does work under someone else's accountability
- **Multiple C's**: Complex decisions requiring input from many stakeholders
- **Multiple I's**: Decisions with broad organizational impact

### When to Update
- New team member joins
- Process changes
- New tools introduced
- Feedback from retrospectives
- Quality gate failures

---

**Document Owner**: PMO Team  
**Last Updated**: January 2025  
**Review Frequency**: Quarterly  
**Next Review**: April 2025

---

*This RACI matrix ensures clear accountability and communication across all teams in the Azure E2E workflow.*
