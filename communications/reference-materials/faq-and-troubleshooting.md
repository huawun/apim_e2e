# FAQ and Troubleshooting - Azure E2E Workflow

Common questions and solutions for the Azure End-to-End Production Workflow.

---

## General Workflow Questions

### Q: How long does the complete workflow take?
**A:** Timeline varies by complexity:
- **Simple apps**: 1-2 weeks
- **Standard apps**: 2-3 weeks
- **Complex apps**: 3-4 weeks

Breakdown:
- Planning & Architecture: 2-3 days
- Security & Identity: 1-2 days
- Infrastructure: 1 day
- Development: 3-7 days
- Deployment: 1 day
- API Management: 1 day
- Documentation: 1 day

### Q: What if I need to expedite the process?
**A:** 
1. Mark Jira ticket as "High Priority"
2. Provide complete requirements upfront
3. Have all stakeholders available for quick decisions
4. Consider reducing scope for MVP
5. Contact PMO for resource allocation

Minimum possible timeline: 3-5 days for critical business needs

### Q: Can phases be done in parallel?
**A:** Some phases can overlap:
- ✅ API Governance can start during Security review
- ✅ Infrastructure can be provisioned during Development
- ✅ API documentation can be drafted before deployment
- ❌ Can't deploy before infrastructure is ready
- ❌ Can't configure APIM before app is deployed

### Q: What if a phase is blocked?
**A:**
1. Update Jira ticket with blocker details
2. Post in Teams #enterprise-applications channel
3. Tag the blocking team directly
4. Escalate to team lead if no response in 4 hours
5. PMO can facilitate resolution

---

## Team-Specific Questions

### Business Owner Questions

**Q: What information do I need to submit a request?**
**A:** Minimum requirements:
- Application name and description
- Business justification
- Expected user count (internal/external)
- Data sensitivity level
- Compliance requirements (GDPR, HIPAA, etc.)
- Budget estimate
- Target go-live date
- Integration requirements

**Q: How do I track my request?**
**A:**
- Jira dashboard shows all your requests
- Teams notifications for status changes
- Weekly email summaries
- Can request ad-hoc status update from PMO

**Q: What if requirements change mid-project?**
**A:**
1. Create "Change Request" Jira ticket
2. Link to original request
3. Architecture team will assess impact
4. May require re-approval if significant
5. Timeline and budget may be adjusted

---

### Solution Architect Questions

**Q: Where do I find architecture templates?**
**A:** SharePoint → Architecture Library → Templates
- High-Level Design template (Visio)
- Data Flow template
- Integration diagram template
- ADR (Architecture Decision Record) template

**Q: How do I handle conflicting requirements?**
**A:**
1. Document both options with pros/cons
2. Present to Architecture Review Board
3. Make recommendation with justification
4. Board makes final decision
5. Document decision in ADR

**Q: What if proposed technology isn't on approved list?**
**A:**
1. Document business justification
2. Assess risks and mitigation
3. Submit exception request to Architecture Board
4. Include proof of concept if available
5. May require CTO approval

---

### Identity Team Questions

**Q: What naming convention should I use for app registrations?**
**A:** `[AppName]-[Environment]`
- Examples: MyApp-Dev, MyApp-Test, MyApp-Prod
- Use PascalCase
- No special characters except hyphen
- Maximum 120 characters

**Q: How do I handle multi-environment setups?**
**A:**
- Create separate app registration for each environment
- Use parameterized PowerShell script
- Document all three registrations
- Each requires separate Security approval

**Q: Client secret is about to expire, what should I do?**
**A:**
1. Generate new secret 30 days before expiry
2. Coordinate with Dev team for update
3. Update Key Vault with new secret
4. Test in non-production first
5. Delete old secret after confirmation

---

### Security Team Questions

**Q: How do I decide if a permission is too broad?**
**A:** Consider:
- Does it follow least-privilege principle?
- Can a more restrictive permission work?
- What's the blast radius if compromised?
- Is there proper justification?
- Are mitigating controls in place?

Use the decision matrix in your team deck.

**Q: What if I'm unsure about approving a permission?**
**A:**
1. Never rush approval
2. Ask clarifying questions in Jira
3. Consult with Security Lead
4. Escalate to Security Director if needed
5. Request additional controls if approving

**Q: How do I handle emergency after-hours requests?**
**A:**
1. Assess true business impact
2. Grant minimum permission needed
3. Document as emergency exception
4. Set 7-day review deadline
5. Notify Security Director next business day

---

### Platform Team Questions

**Q: How do I handle Terraform state conflicts?**
**A:**
1. Check if another pipeline is running
2. Wait for completion or contact team member
3. If stuck, use: `terraform force-unlock <lock-id>`
4. Review audit logs to prevent recurrence

**Q: What if Azure resource quota is exceeded?**
**A:**
1. Check current usage: `az vm list-usage --location eastus`
2. Request quota increase via Azure Portal
3. Typical approval time: 24-48 hours
4. Consider alternative regions if urgent

**Q: How do I roll back infrastructure changes?**
**A:**
1. Git revert the Terraform changes
2. Push to repository
3. Run pipeline to apply previous state
4. Verify in Azure Portal
5. Document incident and root cause

---

### Development Team Questions

**Q: How do I test Entra ID authentication locally?**
**A:**
1. Get dev app registration details from Identity team
2. Update appsettings.json with dev credentials
3. Use `dotnet user-secrets` for local secrets
4. Test with your own Entra ID account
5. Join Azure AD test users group if needed

**Q: Key Vault access denied when testing?**
**A:**
1. Verify managed identity is assigned (Platform team)
2. Check Key Vault access policies
3. Confirm correct Key Vault URL
4. Test with Azure CLI: `az keyvault secret show`
5. Contact Platform team if still failing

**Q: Docker container won't start in App Service?**
**A:**
1. Check container logs in Azure Portal
2. Verify EXPOSE port matches App Service config
3. Test container locally first
4. Check environment variables are set
5. Verify image exists in ACR

---

### DevOps Team Questions

**Q: Pipeline fails at random steps, how do I debug?**
**A:**
1. Check pipeline logs for error messages
2. Verify service connections are valid
3. Check Azure service health status
4. Run pipeline with verbose logging
5. Test steps manually if needed

**Q: How do I handle concurrent deployments?**
**A:**
- Use deployment gates/locks
- Configure pipeline queue settings
- Deploy to different environments
- Use deployment slots for zero-downtime
- Coordinate with team in Teams channel

**Q: Deployment succeeded but app isn't working?**
**A:**
1. Check health endpoint
2. Review Application Insights logs
3. Verify environment variables
4. Check managed identity permissions
5. Review App Service configuration

---

### API Team Questions

**Q: How do I test APIM policies locally?**
**A:**
- No local testing for APIM policies
- Use APIM test console in Azure Portal
- Create test subscription key
- Test with Postman using test key
- Deploy to dev APIM instance first

**Q: Rate limit not working as expected?**
**A:**
1. Verify policy is in correct section (inbound)
2. Check policy scope (product/API/operation)
3. Test with multiple requests
4. Check APIM analytics for rate limit hits
5. Verify subscription tier

**Q: JWT validation failing?**
**A:**
1. Verify OpenID configuration URL
2. Check audience matches app ID
3. Test token at jwt.ms
4. Verify token hasn't expired
5. Check APIM diagnostic logs

---

### Operations Team Questions

**Q: Alert fatigue - too many non-critical alerts?**
**A:**
1. Review alert thresholds
2. Adjust severity levels
3. Group related alerts
4. Implement alert suppression logic
5. Regular alert tuning sessions

**Q: How do I investigate performance degradation?**
**A:**
1. Check Application Insights performance blade
2. Review recent deployments
3. Compare with historical baselines
4. Check dependency call times
5. Review resource utilization metrics

**Q: Dashboard shows wrong data?**
**A:**
1. Check data source is correct
2. Verify time range is set properly
3. Clear browser cache
4. Refresh Application Insights connection
5. Recreate queries if needed

---

## Technical Troubleshooting

### Authentication Issues

**Issue**: Users can't sign in
```
Symptoms:
- Login redirect fails
- "Access denied" errors
- Infinite redirect loop

Troubleshooting Steps:
1. Verify app registration redirect URIs
2. Check conditional access policies
3. Test with different browser/incognito
4. Review Entra ID sign-in logs
5. Check if user is in correct group

Common Fixes:
- Add missing redirect URI
- User not in app group → Add to group
- CA policy blocking → Adjust policy
- Token expired → Clear cookies and retry
```

**Issue**: API returns 401 Unauthorized
```
Symptoms:
- API calls fail with 401
- JWT validation errors in APIM logs

Troubleshooting Steps:
1. Verify Authorization header format
2. Check token hasn't expired (jwt.ms)
3. Verify audience claim matches
4. Check APIM JWT validation policy
5. Test with fresh token

Common Fixes:
- Wrong audience → Update app registration
- Token expired → Get new token
- Missing scope → Add required scope
- Policy misconfigured → Fix APIM policy
```

---

### Deployment Issues

**Issue**: Docker image won't push to ACR
```
Symptoms:
- "unauthorized" error
- "manifest unknown" error
- Timeout during push

Troubleshooting Steps:
1. Verify ACR authentication: `az acr login --name myacr`
2. Check ACR exists and name is correct
3. Verify network connectivity
4. Check ACR service is healthy
5. Review Azure DevOps service connection

Common Fixes:
- Not authenticated → Run az acr login
- Wrong ACR name → Fix in pipeline
- Service connection expired → Renew
- Network issue → Check firewall rules
```

**Issue**: App Service shows "Application Error"
```
Symptoms:
- Generic error page
- Container won't start
- Application Insights shows no data

Troubleshooting Steps:
1. Check App Service logs: Deployment Center → Logs
2. Review container logs
3. Check Application Insights for exceptions
4. Verify environment variables
5. Test container locally

Common Fixes:
- Missing env var → Add in App Service config
- Container crash → Fix code and redeploy
- Port mismatch → Update EXPOSE in Dockerfile
- Resource quota → Scale up App Service plan
```

---

### Infrastructure Issues

**Issue**: Terraform apply fails
```
Symptoms:
- Resource creation errors
- State lock errors
- Provider authentication failures

Troubleshooting Steps:
1. Check Terraform error message
2. Verify Azure credentials
3. Check resource quotas
4. Review Terraform state
5. Validate Terraform syntax

Common Fixes:
- State locked → force-unlock
- Quota exceeded → Request increase
- Auth failed → Renew service principal
- Resource conflict → Import existing resource
- Syntax error → Fix Terraform files
```

**Issue**: Key Vault access denied
```
Symptoms:
- App can't retrieve secrets
- 403 Forbidden errors

Troubleshooting Steps:
1. Verify managed identity is enabled
2. Check Key Vault access policies
3. Confirm correct Key Vault URL
4. Test with Azure CLI
5. Review audit logs

Common Fixes:
- Missing access policy → Add managed identity
- Wrong Key Vault → Update URL
- Network restricted → Add IP to firewall
- Deleted secret → Recover or recreate
```

---

### Performance Issues

**Issue**: Slow API response times
```
Symptoms:
- Response time > 2 seconds
- Timeout errors
- User complaints

Troubleshooting Steps:
1. Check Application Insights performance
2. Review dependency call times
3. Check database query performance
4. Review recent code changes
5. Check resource utilization

Common Fixes:
- Slow query → Add database index
- External API slow → Add caching
- High CPU → Scale up/out
- Memory leak → Fix code and restart
- Network latency → Use Azure region closer to users
```

---

## Emergency Procedures

### Production Down

**Severity: P1 - Critical**

```
Immediate Actions (First 5 minutes):
1. Post in Teams #incidents with @here
2. Create Jira incident ticket
3. Assemble war room (Teams call)
4. Identify impact scope
5. Begin investigation

Investigation (5-15 minutes):
1. Check Application Insights
2. Review recent deployments
3. Check Azure service health
4. Review error patterns
5. Identify root cause

Resolution Options:
A. Rollback deployment (if recent deploy)
   - Use Azure DevOps pipeline
   - Swap deployment slots
   - ~5 minutes

B. Quick fix (if simple issue)
   - Fix configuration
   - Restart services
   - ~10 minutes

C. Hotfix deployment (if code issue)
   - Create hotfix branch
   - Emergency pipeline run
   - ~30 minutes

Post-Incident (Within 24 hours):
1. Document incident in Jira
2. Schedule post-mortem meeting
3. Create action items
4. Update runbooks
5. Communicate to stakeholders
```

---

### Security Incident

**Severity: P1 - Critical**

```
Immediate Actions:
1. Contact Security On-Call immediately
2. Do NOT make changes without approval
3. Preserve logs and evidence
4. Document everything
5. Isolate affected systems if needed

Security Team Actions:
1. Assess severity and scope
2. Determine if breach occurred
3. Follow incident response plan
4. Engage legal/compliance if needed
5. Coordinate remediation

Communication:
- Internal: Security Director, CISO
- External: May need legal approval
- Timeline: Follow company policy
```

---

## Best Practices

### For All Teams

✅ **Do**:
- Update Jira tickets regularly
- Communicate proactively in Teams
- Document decisions and changes
- Follow naming conventions
- Test in non-production first
- Ask questions when unsure
- Share knowledge with team

❌ **Don't**:
- Skip security reviews
- Make unauthorized changes
- Leave incidents unresolved
- Share credentials in chat
- Deploy on Fridays (if avoidable)
- Ignore alerts
- Assume without verifying

---

## Getting Help

### Quick Reference

| Issue Type | Contact | Channel | SLA |
|-----------|---------|---------|-----|
| General question | PMO | Teams #enterprise-applications | 4 hours |
| Technical blocker | Team Lead | Direct message | 2 hours |
| Security concern | Security Team | security-team@company.com | 4 hours |
| Production down | On-Call | Teams #incidents | Immediate |
| Tool access | IT Support | it-support@company.com | 1 day |

### Escalation

```
Level 1: Team member → Team Lead (Teams)
Level 2: Team Lead → Manager (Teams + Jira)
Level 3: Manager → Director (Email + Meeting)
Level 4: Director → Executive (Formal escalation)
```

---

## Useful Commands

### Azure CLI
```bash
# Login
az login
az account set --subscription "Production"

# List resources
az resource list --resource-group myapp-prod-rg

# App Service
az webapp show --name myapp-prod-app --resource-group myapp-prod-rg
az webapp log tail --name myapp-prod-app --resource-group myapp-prod-rg

# Container Registry
az acr login --name myacr
az acr repository list --name myacr

# Key Vault
az keyvault secret show --name mySecret --vault-name myapp-prod-kv
```

### PowerShell
```powershell
# Login
Connect-AzAccount
Set-AzContext -Subscription "Production"

# App Registration
Get-AzADApplication -DisplayName "MyApp-Production"
New-AzADAppCredential -ObjectId $app.Id

# Resource Group
Get-AzResourceGroup -Name "myapp-prod-rg"
Get-AzResource -ResourceGroupName "myapp-prod-rg"
```

### Docker
```bash
# Build and tag
docker build -t myapp .
docker tag myapp myacr.azurecr.io/myapp:latest

# Push to registry
docker push myacr.azurecr.io/myapp:latest

# Run locally
docker run -p 8080:80 myapp

# Debug
docker logs <container-id>
docker exec -it <container-id> /bin/bash
```

---

## Glossary

**ACR**: Azure Container Registry  
**APIM**: Azure API Management  
**CA**: Conditional Access  
**IaC**: Infrastructure as Code  
**JWT**: JSON Web Token  
**MFA**: Multi-Factor Authentication  
**RBAC**: Role-Based Access Control  
**SLA**: Service Level Agreement  
**SPN**: Service Principal Name

---

**Document Owner**: PMO Team  
**Last Updated**: January 2025  
**Feedback**: Contact pmo@company.com  
**Updates**: Monthly based on common issues

---

*This FAQ is a living document. Please submit questions and solutions to help improve it for everyone.*
