# Security Team - Communication Deck

## 🎯 Your Role in the Workflow

As part of the **Security Team**, you are the **approval authority and policy enforcer** for all security-related configurations. Working in a hybrid model with the Identity Team, you review, approve, and configure security controls.

---

## 📋 Your Primary Responsibilities

### What You Own
1. **Permission Approval**: Review and approve/reject API permission requests
2. **Admin Consent**: Grant admin consent for approved permissions
3. **Conditional Access**: Configure conditional access policies
4. **Security Policies**: Enforce organizational security standards
5. **Security Audits**: Regular security reviews and compliance checks

### What Identity Team Owns (Hybrid Model)
- App registration technical creation
- Authentication flow configuration
- Service principal setup
- User group creation

### What Success Looks Like
- ✅ All permissions reviewed within 1 business day
- ✅ Zero security incidents from misconfigured permissions
- ✅ 100% compliance with security policies
- ✅ Clear audit trail for all approvals
- ✅ Effective partnership with Identity Team

---

## 🛠️ Tools You'll Use Daily

### Primary Tools
| Tool | Purpose | Your Daily Use |
|------|---------|---------------|
| **Azure Portal** | Security management | Review permissions, grant consent, configure policies |
| **Azure Security Center** | Security posture | Monitor security recommendations |
| **Microsoft Defender** | Threat protection | Review security alerts |
| **Jira** | Approval workflow | Review and approve requests |
| **Microsoft Teams** | Communication | Coordinate with Identity Team |
| **SharePoint** | Documentation | Security policies, audit logs |

### Tool Access Required
- [ ] Azure Portal - Security administrator role
- [ ] Conditional Access Administrator role
- [ ] Security Center access
- [ ] Jira security project access
- [ ] Teams #identity-security channel
- [ ] SharePoint security library access

---

## 🔄 Your Workflow: Step-by-Step

### Phase 2: Security Review & Approval (YOUR PRIMARY PHASE)

#### Step 1: Receive Request from Identity Team
**Time Required**: 15 minutes

```
Input from Identity Team (via Jira):
├─ Application name
├─ Business justification
├─ Requested API permissions
├─ User types and access patterns
└─ App registration details

Your Initial Assessment:
├─ Review business case
├─ Assess permission scope
├─ Check compliance requirements
└─ Identify security risks
```

#### Step 2: Permission Review
**Time Required**: 30-60 minutes per request

**Review Criteria:**

```
Azure Portal → Entra ID → App Registration → API permissions

For Each Requested Permission, Evaluate:

1. Principle of Least Privilege
   ❓ Is this the minimum permission needed?
   ❓ Can a more restrictive permission work instead?
   
2. Business Justification
   ❓ Does the business case support this permission?
   ❓ What specific feature requires this permission?
   
3. Data Access
   ❓ What data will the app access?
   ❓ Is the data sensitive/regulated?
   
4. Risk Assessment
   ❓ What's the impact if this app is compromised?
   ❓ Are there mitigating controls?
   
5. Compliance
   ❓ Does this meet GDPR/HIPAA requirements?
   ❓ Any regulatory concerns?

Decision Matrix:
┌────────────────────────────────────────────────────────┐
│ Permission Scope    │ Business Need  │ Decision        │
├────────────────────────────────────────────────────────┤
│ Low                 │ Strong         │ ✅ APPROVE      │
│ Low                 │ Weak           │ ❌ REJECT       │
│ Medium              │ Strong         │ ✅ APPROVE      │
│ Medium              │ Weak           │ 🔄 REQUEST MORE │
│ High                │ Strong         │ 👤 ESCALATE     │
│ High                │ Weak           │ ❌ REJECT       │
└────────────────────────────────────────────────────────┘
```

**Common Permission Scenarios:**

```
USER.READ (Delegated)
Risk: LOW ✅
Common Use: Basic user profile access
Decision: Almost always approved

USER.READWRITE.ALL (Delegated)
Risk: HIGH ⚠️
Common Use: Modify all user profiles
Decision: Requires strong justification
Alternative: User.ReadWrite.Self (only modify own profile)

USER.READ.ALL (Application)
Risk: MEDIUM ⚠️
Common Use: Background jobs reading user data
Decision: Requires business justification
Mitigations: Conditional access, audit logging

MAIL.SEND (Delegated)
Risk: MEDIUM ⚠️
Common Use: Send emails on behalf of user
Decision: Usually approved with rate limiting
Mitigations: APIM rate limiting, monitoring

DIRECTORY.READWRITE.ALL (Application)
Risk: VERY HIGH 🚨
Common Use: Modify directory objects
Decision: Rarely approved, escalate to Security Director
```

#### Step 3: Make Decision
**Time Required**: 15 minutes

**Option A: APPROVE**
```
Update Jira Ticket:
Status: Approved - Ready for Admin Consent

Decision: APPROVED ✅
Reviewed by: [Your Name]
Date: [Date]

Justification: [Brief explanation]

Conditions/Requirements:
- Conditional access policy required
- MFA enforced for all users
- Access review every 6 months

Next Steps:
1. I will grant admin consent
2. I will configure conditional access policy
3. Identity Team: Notify Dev Team
```

**Option B: REJECT**
```
Update Jira Ticket:
Status: Rejected - Requires Modification

Decision: REJECTED ❌
Reviewed by: [Your Name]
Date: [Date]

Reason for Rejection:
[Specific security concern]

Recommendation:
Instead of [rejected permission], consider using [alternative permission]
because [explanation].

Example: Instead of User.ReadWrite.All, use User.ReadBasic.All 
which provides directory search without write access.

Next Steps:
1. Business Owner: Review alternative
2. Identity Team: Reconfigure if alternative accepted
3. Resubmit for security review
```

**Option C: REQUEST MORE INFORMATION**
```
Update Jira Ticket:
Status: Pending Information

Questions:
1. What specific user data does the app need to access?
2. How many users will have this permission?
3. Is this for user context or application context?
4. What's the retention period for accessed data?

Please provide this information so we can complete our review.
```

#### Step 4: Grant Admin Consent (If Approved)
**Time Required**: 15 minutes

```
Azure Portal → Entra ID → App Registration → API permissions

1. Verify all permissions are still as reviewed
2. Click "Grant admin consent for [tenant name]"
3. Review confirmation dialog carefully
4. Click "Yes"

Confirmation:
✅ Admin consent granted for:
   - Microsoft Graph: User.Read
   - Microsoft Graph: User.ReadBasic.All
   
Date: [Timestamp]
Granted by: [Your Name]
```

**Post-Consent Actions:**
```powershell
# Document the consent in audit log
$auditEntry = @{
    Timestamp = Get-Date
    AppName = "MyApp-Production"
    AppId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    PermissionsGranted = @("User.Read", "User.ReadBasic.All")
    GrantedBy = $env:USERNAME
    BusinessJustification = "User directory access for employee lookup"
    JiraTicket = "PROJ-1234"
} | ConvertTo-Json

Add-Content -Path "security-audit-log.json" -Value $auditEntry
```

#### Step 5: Configure Conditional Access (If Required)
**Time Required**: 30-60 minutes

```
Azure Portal → Entra ID → Security → Conditional Access

Create New Policy: "MyApp-Production-CA"

Assignments:
├─ Users: Include "MyApp-Users-Prod" group
├─ Cloud apps: Select "MyApp-Production"
├─ Conditions:
│  ├─ Locations: Exclude trusted office locations
│  ├─ Device platforms: All
│  └─ Client apps: All

Access Controls:
├─ Grant:
│  ├─ ☑ Require multi-factor authentication
│  ├─ ☑ Require device to be marked as compliant
│  └─ Require all selected controls
└─ Session:
   └─ Sign-in frequency: 8 hours

Enable Policy: Report-only (test first)
                ↓
             On (after validation)
```

**Test Conditional Access:**
```
1. Use test user account
2. Attempt to access MyApp
3. Verify MFA prompt appears
4. Verify access granted after MFA
5. Document test results
6. Enable policy for production
```

#### Step 6: Documentation & Handoff
**Time Required**: 15 minutes

**Update Jira:**
```
Status: Security Approved - Ready for Development

Security Configuration Complete:
✅ API permissions reviewed and approved
✅ Admin consent granted
✅ Conditional access policy configured
✅ Security documentation updated

Security Controls Implemented:
- MFA required for all users
- Compliant device required
- Session timeout: 8 hours
- Access review: Every 6 months

@Dev-Team - You can now integrate authentication.
Application ID and tenant ID are in Azure DevOps.

@Identity-Team - Security configuration complete.
```

**Update SharePoint Security Log:**
```markdown
# Security Approval - MyApp Production

## Approval Details
- **Date**: 2025-01-15
- **Approved by**: security-reviewer@company.com
- **Jira Ticket**: PROJ-1234

## Permissions Approved
| API | Permission | Type | Risk Level |
|-----|-----------|------|------------|
| Microsoft Graph | User.Read | Delegated | Low |
| Microsoft Graph | User.ReadBasic.All | Delegated | Medium |

## Risk Mitigation
- Conditional access policy enforced
- MFA required
- Device compliance required
- Regular access reviews scheduled

## Audit Trail
- Admin consent granted: 2025-01-15 10:30 AM
- Conditional access policy created: 2025-01-15 10:45 AM
- Policy tested and enabled: 2025-01-15 11:00 AM
```

---

## 📊 Your Involvement by Phase

```
Phase 1: REQUEST & PLANNING
YOUR REVIEW ROLE: 10% involvement
└─ Review security requirements

Phase 2: SECURITY & IDENTITY
YOUR LEAD ROLE: 30% involvement (Approval & Policies)
├─ Review API permissions ✓ YOU
├─ Approve/reject requests ✓ YOU
├─ Grant admin consent ✓ YOU
├─ Configure conditional access ✓ YOU
└─ Document security controls ✓ YOU

(Identity Team: 70% - Technical Implementation)

Phase 3: INFRASTRUCTURE
YOUR REVIEW ROLE: 40% involvement
├─ Review network security
├─ Approve Key Vault access
└─ Validate security configurations

Phase 4-7: All Other Phases
YOUR MONITORING ROLE: 10-20% involvement
├─ Monitor security alerts
├─ Review audit logs
└─ Respond to security incidents
```

---

## 🚦 Quality Gates - Your Approvals Required

### Gate 1: Permission Approved ✅
**Your Action Required**: Review and approve/reject

Checklist before approval:
- [ ] Business justification reviewed and adequate
- [ ] Permissions follow least-privilege principle
- [ ] Compliance requirements met
- [ ] Risk assessment completed
- [ ] Mitigation controls identified
- [ ] Audit trail documented

**How to Approve**: Jira ticket → "Approve Security"

### Gate 2: Conditional Access Configured ✅
**Your Action Required**: Configure and test policies

Checklist before enabling:
- [ ] Policy created with appropriate controls
- [ ] Test user validation completed
- [ ] Documentation updated
- [ ] Rollback plan prepared

**How to Complete**: Azure Portal → Enable CA policy

---

## 🗓️ Your Daily Routine

### Morning (1 hour)
- Review new security requests in Jira
- Check Security Center for alerts
- Review overnight audit logs

### Mid-Morning (2 hours)
- Process permission approval requests
- Grant admin consent for approved apps
- Configure conditional access policies

### Afternoon (2 hours)
- Security posture reviews
- Compliance checks
- Documentation updates

### End of Day (30 minutes)
- Update Jira tickets
- Communicate decisions to teams
- Plan next day priorities

---

## 💬 Common Scenarios & How to Handle

### Scenario 1: Overly Broad Permission Request
```
Situation: App requests User.ReadWrite.All but only needs User.Read
Your Actions:
1. Update Jira: Status = Pending Information
2. Ask: "What specific user data needs to be modified?"
3. Review response
4. Suggest alternative: User.ReadBasic.All or User.Read
5. Work with Identity Team to reconfigure
6. Re-review with narrower scope

Communication Template:
"Hi [Identity Team], I've reviewed the permission request for 
MyApp. The requested User.ReadWrite.All permission is broader 
than necessary. Based on the business case, User.ReadBasic.All 
would provide the needed directory search capability without 
write access. Can we reconfigure with this more restrictive 
permission? This follows our least-privilege policy and reduces 
risk while still meeting the business need."
```

### Scenario 2: Urgent Production Issue
```
Situation: App in production can't access resource, blocking business
Your Actions:
1. Assess immediate business impact
2. Review what permission is needed
3. If reasonable:
   - Grant temporary approval
   - Document as emergency exception
   - Set 7-day review period
4. If high-risk:
   - Escalate to Security Director
   - Conference call with stakeholders
   - Make decision with management approval
5. Follow up with proper review within 7 days

Emergency Approval Process:
- Document in Jira: "Emergency Approval - [Reason]"
- Send email to Security Director
- Grant minimum permission needed
- Schedule follow-up review
- Add to next security review meeting
```

### Scenario 3: External Partner Access
```
Situation: External partner needs access to internal APIs
Your Actions:
1. Require business approval at Director level
2. Additional security controls:
   - Guest user accounts (not service principal if possible)
   - Strict conditional access:
     * Require MFA
     * Specific IP ranges only
     * Limited time access
   - Enhanced monitoring and alerting
3. Document partner organization
4. Set up quarterly access reviews
5. Require legal/contracts review

Extra Requirements:
- Data sharing agreement signed
- Partner security assessment completed
- Incident response plan documented
- Regular audits scheduled
```

### Scenario 4: Compliance Violation
```
Situation: Existing app found with excessive permissions
Your Actions:
1. Assess current risk and impact
2. Create Jira incident ticket
3. Contact app owner immediately
4. Options:
   a) Revoke permission immediately (if high risk)
   b) Set 30-day remediation deadline (if medium risk)
   c) Schedule permission review (if low risk)
5. Work with Identity Team to reconfigure
6. Document in compliance report
7. Follow up to verify remediation

Escalation:
- High risk → Revoke immediately + Security Director notification
- Medium risk → 30-day deadline + weekly status updates
- Low risk → Schedule review + monthly follow-up
```

---

## 📈 Success Metrics You Own

### Review Performance
- **Review turnaround time**: <1 business day
- **Approval accuracy**: >95% (minimal reversals)
- **Security incident rate**: <1 per quarter
- **Compliance rate**: 100% for all apps

### Security Posture
- **Zero high-risk permission approvals**: Without proper controls
- **Conditional access coverage**: 100% of production apps
- **MFA enforcement**: 100% for sensitive apps
- **Regular access reviews**: 100% completion quarterly

---

## 🤝 Key Relationships

### Teams You Work With Closely

#### Identity Team (Daily)
- **Hybrid Model Partners**: They implement, you approve
- **What they need from you**: Timely approval decisions, clear security requirements
- **What you get from them**: Proper configurations, documentation
- **Communication**: Jira tickets, Teams #identity-security channel
- **Handoff Point**: After they configure, you approve and grant consent

#### Business Owners (Per request)
- **What they need from you**: Security approval, guidance on compliance
- **What you get from them**: Business justification, use cases
- **Communication**: Security review meetings

#### Platform Team (Weekly)
- **What they need from you**: Security requirements for infrastructure
- **What you get from them**: Infrastructure security configuration
- **Communication**: Security architecture reviews

---

## 📚 Security Standards & Policies

### Permission Approval Guidelines

**Always Approve (Low Risk):**
- User.Read (Delegated)
- Profile reading for authenticated user
- Basic directory search

**Conditional Approval (Medium Risk):**
- User.ReadBasic.All (Delegated) - With MFA
- Mail.Send (Delegated) - With rate limiting
- Files.Read (Delegated) - With scope limitation

**Rarely Approve (High Risk):**
- *.ReadWrite.All (Any) - Requires Director approval
- Directory.* (Application) - Requires CISO approval
- Privileged operations - Escalate

**Never Approve (Very High Risk):**
- RoleManagement.ReadWrite.All
- Application.ReadWrite.All
- Without proper justification and controls

---

## ❓ FAQ

**Q: How long does security review take?**
A: Standard requests: <1 business day. Complex/high-risk: 2-3 days with escalation.

**Q: What if I'm not sure about a permission?**
A: Escalate to Security Lead or Security Director. Better safe than sorry.

**Q: Can I approve and grant consent simultaneously?**
A: Yes, if you're comfortable with the permission. Document your review.

**Q: What if Business Owner pressures for quick approval?**
A: Security cannot be rushed. Explain the risks. Escalate if needed.

**Q: How do I handle emergency requests?**
A: Use emergency approval process with temporary access and mandatory follow-up review.

**Q: What if I made a mistake in approval?**
A: Immediately revoke the permission, notify Security Director, create incident ticket.

---

## 🎯 Quick Wins - Your First 30 Days

### Week 1: Learning
- [ ] Shadow senior security reviewer
- [ ] Review past 20 approval decisions
- [ ] Learn permission risk levels
- [ ] Understand conditional access policies

### Week 2: Supervised Reviews
- [ ] Review requests with supervision
- [ ] Practice approval decisions
- [ ] Configure test conditional access policy
- [ ] Learn escalation procedures

### Week 3: Independent Reviews (Low Risk)
- [ ] Handle low-risk approvals independently
- [ ] Configure conditional access policies
- [ ] Update documentation
- [ ] Build relationships with Identity Team

### Week 4: Full Responsibility
- [ ] Handle all risk levels (with escalation)
- [ ] Conduct security audits
- [ ] Contribute to policy improvements
- [ ] Mentor new team members

---

## 📞 Who to Contact

### Daily Questions
- **Security Team Lead**: security-lead@company.com
- **Teams Channel**: #security-team
- **Response Time**: <2 hours

### Escalations
- **Security Director**: security-director@company.com
- **CISO Office**: ciso@company.com
- **Use for**: High-risk permissions, policy exceptions

### Incidents
- **Security On-Call**: security-oncall@company.com
- **Security Operations Center**: soc@company.com
- **Use for**: Active security incidents, breaches

---

## ✅ Your Onboarding Checklist

- [ ] Read this entire deck
- [ ] Complete tool access requests
- [ ] Review security policies and standards
- [ ] Complete Microsoft security training
- [ ] Shadow 10 approval decisions
- [ ] Learn conditional access configuration
- [ ] Meet Identity Team counterparts
- [ ] Review past security incidents
- [ ] Join all required Teams channels
- [ ] Set up approval dashboard in Jira

---

**Document Owner**: Security Team Lead  
**Last Updated**: January 2025  
**Questions?** Post in Teams #security-team channel  
**Feedback?** Contact security-lead@company.com

---

*As part of the Security Team, you are the guardian of organizational security. Your approval decisions protect the company while enabling business agility.*
