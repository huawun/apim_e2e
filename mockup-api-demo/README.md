# Mockup API Demo — End-to-End Sprint 1 Pipeline Template

A self-contained reference implementation demonstrating the full Sprint 1 API lifecycle pipeline — from OpenAPI spec authoring through Spectral linting, Backstage catalog registration, APIM onboarding via IaC, policy fragment binding, and security validation testing.

This template uses a single minimal API (`GET /v1/demo-users`) to exercise every pipeline stage. Clone and adapt it when onboarding real APIs (e.g., the 9 User Profile APIs).

## Directory Structure

```
mockup-api-demo/
├── spec/
│   └── demo-users-api.yaml          # OpenAPI 3.x specification
├── lint/
│   └── .spectral.yaml               # ADR-015 Spectral ruleset
├── catalog/
│   └── catalog-info.yaml            # Backstage catalog entry
├── iac/
│   ├── main.tf                      # APIM API + Product + Backend
│   ├── variables.tf                 # Parameterized env settings
│   ├── policies.tf                  # Policy fragment bindings
│   └── terraform.tfvars.example     # Example variable values
├── tests/
│   └── security-validation.sh       # curl-based security tests
├── demo-script.md                   # Step-by-step walkthrough
└── README.md                        # This file
```

## Artifact Guide

### `spec/demo-users-api.yaml` — OpenAPI Specification

Complete OpenAPI 3.x contract for the mockup `GET /v1/demo-users` endpoint. Includes:

- Path-based versioning (`/v1/` prefix) per ADR-015
- `bearerAuth` security scheme referencing Entra ID JWT validation (ADR-007)
- Standardized `ErrorResponse` schema (`error.code`, `error.message`, `error.details[]`) per ADR-015
- Example response payloads for 200 success and 401 unauthorized cases
- Full `info` metadata (title, version, description, contact)

### `lint/.spectral.yaml` — Spectral Ruleset

Machine-enforceable ADR-015 design rules for shift-left API governance (ADR-002). Rules include:

| Rule ID | What It Checks | Severity |
| --- | --- | --- |
| `adr015-path-versioning` | All paths start with `/v{n}/` | error |
| `adr015-bearer-auth` | `securitySchemes` includes `bearerAuth` with `type: http` | error |
| `adr015-error-schema` | `ErrorResponse` schema has `error.code`, `error.message`, `error.details` | error |
| `adr015-info-metadata` | `info` includes title, version, description, contact | warning |
| `adr015-example-responses` | Operations include examples for success and error responses | warning |

This ruleset is reusable as-is for all APIs — no modification needed when adapting the template.

### `catalog/catalog-info.yaml` — Backstage Catalog Entry

Registers the API in the Backstage Software Catalog with:

- `kind: API` and `type: openapi`
- `lifecycle: experimental` (change to `production` when the API is live)
- `owner` set to the team identifier (marked with `TODO` for replacement)
- `system: user-profile` for business domain grouping
- `definition` linking the OpenAPI spec via relative file path

See ADR-001 (Backstage as sole developer portal) for catalog conventions.

### `iac/` — Terraform Infrastructure as Code

Onboards the API into Azure API Management using versioned, parameterized IaC:

- **`main.tf`** — Defines APIM API registration, Bronze product tier, product-API assignment, and backend service. Imports the OpenAPI spec as the API definition source.
- **`variables.tf`** — Parameterized variables for all environment-specific settings. Every variable has a `TODO` comment indicating what to replace.
- **`policies.tf`** — Binds policy fragments at the correct scopes using `<include-fragment>` directives per ADR-004:
  - `JWT-Validation-Internal` → API level (ADR-007)
  - `rate-limit` → Product level (Bronze tier, ADR-012)
  - `cors` → Global level
  - `correlation-id` → Global level (ADR-013)
- **`terraform.tfvars.example`** — Example variable values with `TODO` placeholders. Copy to `terraform.tfvars` and fill in real values.

### `tests/security-validation.sh` — Security Validation Tests

Bash script using `curl` to validate policy enforcement with colored pass/fail output:

| Test | Expected Result |
| --- | --- |
| Valid JWT → `GET /v1/demo-users` | HTTP 200 OK |
| No JWT → `GET /v1/demo-users` | HTTP 401 Unauthorized |
| Invalid JWT → `GET /v1/demo-users` | HTTP 401 Unauthorized |
| Exceed rate limit (Bronze) | HTTP 429 Too Many Requests |
| Disallowed CORS origin | Request blocked |
| Any response | `X-Correlation-ID` header present |
| Error response | Body matches ADR-015 error schema |

### `demo-script.md` — Demo Walkthrough

Step-by-step presenter guide for the show-and-tell session. Maps each stage to Sprint 1 Epics (P01–P04) with exact CLI commands and expected output.

## Adapting This Template for a Real API

Follow these steps to onboard a new API using this template:

### Step 1: Copy the Directory

```bash
cp -r mockup-api-demo/ my-api-name/
cd my-api-name/
```

### Step 2: Rename the API in the OpenAPI Spec

Edit `spec/demo-users-api.yaml` (rename the file to match your API):

- Update `info.title`, `info.description`, and `info.contact`
- Replace the `/v1/demo-users` path with your API's resource path
- Update the `DemoUser` schema to match your API's data model
- Keep the `bearerAuth` security scheme and `ErrorResponse` schema unchanged

### Step 3: Update Backstage Catalog Metadata

Edit `catalog/catalog-info.yaml`:

- Replace `metadata.name` with your API's kebab-case identifier
- Update `metadata.description`
- Replace `spec.owner` with your team's Backstage entity reference (`TODO` marker)
- Update `spec.system` if your API belongs to a different business domain
- Update the `definition.$text` path if you renamed the spec file

### Step 4: Replace `TODO` Placeholders in IaC

Search for all `TODO` comments and replace with real values:

```bash
grep -rn "TODO" iac/
```

Key placeholders in `iac/variables.tf` and `iac/terraform.tfvars.example`:

| Variable | Description | Where to Find the Value |
| --- | --- | --- |
| `resource_group_name` | Azure Resource Group containing APIM | Azure Portal → Resource Groups |
| `apim_instance_name` | APIM instance name | Azure Portal → API Management |
| `backend_url` | Your API's backend service URL | Your deployment configuration |
| `tenant_id` | Microsoft Entra ID tenant ID | Azure Portal → Entra ID → Overview |
| `app_id` | Entra ID App Registration client ID | Azure Portal → App Registrations |
| `issuer_url` | JWT issuer URL (Entra ID STS endpoint) | `https://login.microsoftonline.com/{tenant-id}/v2.0` |

Also replace `TODO` placeholders in:
- `catalog/catalog-info.yaml` — owner field
- `tests/security-validation.sh` — APIM endpoint URL and JWT token values

### Step 5: Run Spectral Lint to Validate

```bash
spectral lint spec/your-api.yaml --ruleset lint/.spectral.yaml
```

Expect zero errors. If errors appear, fix the spec to comply with ADR-015 before proceeding.

### Step 6: Commit and Follow the Pipeline

```bash
git add .
git commit -m "feat: onboard <your-api-name> via golden path template"
git push
```

The CI/CD pipeline will:
1. Run Spectral linting (shift-left governance)
2. Register the API in Backstage catalog
3. Apply Terraform to onboard the API in APIM
4. Bind policy fragments
5. Run security validation tests

## `TODO` Placeholder Reference

All environment-specific values are marked with `TODO` comments throughout the template. Run this command to find them all:

```bash
grep -rn "TODO" .
```

These placeholders ensure no secrets or environment-specific values are committed to source control. Named Values in the IaC configuration reference Terraform variables, so sensitive values (tenant-id, app-id, issuer URL) are injected at apply time — never hardcoded.

## Prerequisites

Before using this template, ensure the following are available:

- **Spectral CLI** — `npm install -g @stoplight/spectral-cli` (for linting)
- **Terraform** — v1.0+ (for IaC deployment)
- **Azure CLI** — authenticated with sufficient RBAC permissions on the APIM resource group
- **APIM Instance** — with pre-provisioned policy fragments (`JWT-Validation-Internal`, `rate-limit`, `cors`, `correlation-id`)
- **Backstage Instance** — with catalog ingestion configured for the repository

## Related Architecture Decision Records

| ADR | Topic | Relevance |
| --- | --- | --- |
| [ADR-015](../ADR/ADR-015-api-design-standards-and-guardrails.md) | API Design Standards & Guardrails | Spectral ruleset encodes these standards |
| [ADR-004](../ADR/ADR-004-policy-as-code-with-fragment-library.md) | Policy-as-Code with Fragment Library | Policy fragments bound via `<include-fragment>` |
| [ADR-006](../ADR/ADR-006-domain-based-api-authorization.md) | Domain-Based API Authorization | Authorization model for API access |
| [ADR-007](../ADR/ADR-007-trusted-subsystem-two-leg-authentication.md) | Trusted Subsystem Two-Leg Authentication | JWT validation pattern used in policy binding |
| [ADR-002](../ADR/ADR-002-shift-left-api-governance.md) | Shift-Left API Governance | Spectral linting as pre-commit governance |
| [ADR-001](../ADR/ADR-001-backstage-as-sole-developer-portal.md) | Backstage as Sole Developer Portal | Catalog registration conventions |
| [ADR-012](../ADR/ADR-012-tiered-traffic-and-rate-limit-design.md) | Tiered Traffic & Rate Limit Design | Bronze product tier rate limiting |
| [ADR-013](../ADR/ADR-013-observability-strategy-and-incident-triage.md) | Observability Strategy | Correlation-ID header injection |
