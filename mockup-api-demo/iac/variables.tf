# =============================================================================
# Variables — Parameterized environment-specific settings
# =============================================================================
# All variables use TODO placeholders. Replace with real values in your
# terraform.tfvars file before running terraform plan/apply.
# =============================================================================

variable "resource_group_name" {
  type        = string
  description = "Azure Resource Group containing the APIM instance"
  # TODO: Replace with your resource group name (e.g., "rg-apim-pilot-dev")
}

variable "apim_instance_name" {
  type        = string
  description = "Name of the Azure APIM instance"
  # TODO: Replace with your APIM instance name (e.g., "apim-apex-pilot")
}

variable "backend_url" {
  type        = string
  description = "Backend service URL for the demo API"
  # TODO: Replace with your backend URL (e.g., "https://demo-users-backend.azurewebsites.net")
}

variable "tenant_id" {
  type        = string
  description = "Microsoft Entra ID tenant ID for JWT validation"
  # TODO: Replace with your Entra ID tenant ID (GUID)
}

variable "app_id" {
  type        = string
  description = "Entra ID App Registration client ID (audience)"
  # TODO: Replace with your app registration client ID (GUID)
}

variable "issuer_url" {
  type        = string
  description = "JWT issuer URL (Entra ID STS endpoint)"
  # TODO: Replace with your issuer URL (e.g., "https://sts.windows.net/<tenant-id>/")
}
