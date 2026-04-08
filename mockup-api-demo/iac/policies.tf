# =============================================================================
# Policies — Policy fragment bindings via <include-fragment> (ADR-004)
# =============================================================================
# All policy fragments are referenced via <include-fragment> directives.
# Zero inline duplicate security logic — fragments are managed centrally.
# Named Values provide environment-specific configuration (tenant-id, app-id,
# issuer URL) so no secrets appear in source code.
# =============================================================================

# ---------------------------------------------------------------------------
# API-level policy — JWT-Validation-Internal via <include-fragment>
# Uses Named Values for tenant-id, app-id, and issuer URL
# ---------------------------------------------------------------------------
resource "azurerm_api_management_api_policy" "demo_users_jwt" {
  api_name            = azurerm_api_management_api.demo_users.name
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name

  xml_content = <<-XML
    <policies>
      <inbound>
        <base />
        <include-fragment fragment-id="JWT-Validation-Internal" />
      </inbound>
      <backend>
        <base />
      </backend>
      <outbound>
        <base />
      </outbound>
      <on-error>
        <base />
      </on-error>
    </policies>
  XML
}

# ---------------------------------------------------------------------------
# Product-level policy — rate-limit via <include-fragment> (Bronze tier)
# ---------------------------------------------------------------------------
resource "azurerm_api_management_product_policy" "bronze_rate_limit" {
  product_id          = azurerm_api_management_product.bronze.product_id
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name

  xml_content = <<-XML
    <policies>
      <inbound>
        <base />
        <include-fragment fragment-id="rate-limit" />
      </inbound>
      <backend>
        <base />
      </backend>
      <outbound>
        <base />
      </outbound>
      <on-error>
        <base />
      </on-error>
    </policies>
  XML
}

# ---------------------------------------------------------------------------
# Global-level policy — cors + correlation-id via <include-fragment>
# ---------------------------------------------------------------------------
resource "azurerm_api_management_policy" "global" {
  api_management_id = data.azurerm_api_management.apim.id

  xml_content = <<-XML
    <policies>
      <inbound>
        <include-fragment fragment-id="cors" />
        <include-fragment fragment-id="correlation-id" />
      </inbound>
      <backend>
        <base />
      </backend>
      <outbound>
        <base />
      </outbound>
      <on-error>
        <base />
      </on-error>
    </policies>
  XML
}

# ---------------------------------------------------------------------------
# Named Values — environment-specific configuration for policy fragments
# These Named Values are referenced by the JWT-Validation-Internal fragment
# at runtime. Values are parameterized via Terraform variables.
# ---------------------------------------------------------------------------
resource "azurerm_api_management_named_value" "tenant_id" {
  name                = "tenant-id"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "tenant-id"
  value               = var.tenant_id
}

resource "azurerm_api_management_named_value" "app_id" {
  name                = "app-id"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "app-id"
  value               = var.app_id
}

resource "azurerm_api_management_named_value" "issuer_url" {
  name                = "issuer-url"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "issuer-url"
  value               = var.issuer_url
}
