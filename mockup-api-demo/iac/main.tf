# =============================================================================
# Main — APIM API registration, Product, Product-API assignment, Backend
# =============================================================================
# Onboards the demo-users-api into Azure API Management with:
#   - API registration importing the OpenAPI spec
#   - Bronze product tier
#   - Product-to-API assignment
#   - Backend service definition
# =============================================================================

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ---------------------------------------------------------------------------
# Data source — reference the existing APIM instance
# ---------------------------------------------------------------------------
data "azurerm_api_management" "apim" {
  name                = var.apim_instance_name
  resource_group_name = var.resource_group_name
}

# ---------------------------------------------------------------------------
# API Registration — import OpenAPI spec with /v1/demo-users URL suffix
# ---------------------------------------------------------------------------
resource "azurerm_api_management_api" "demo_users" {
  name                = "demo-users-api"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Demo Users API"
  path                = "v1/demo-users"
  protocols           = ["https"]
  service_url         = var.backend_url

  import {
    content_format = "openapi"
    content_value  = file("${path.module}/../spec/demo-users-api.yaml")
  }
}

# ---------------------------------------------------------------------------
# Product — Bronze tier
# ---------------------------------------------------------------------------
resource "azurerm_api_management_product" "bronze" {
  product_id          = "bronze"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "Bronze"
  description         = "Bronze product tier — standard rate limits apply."
  published           = true
  subscription_required = true
  approval_required     = false
}

# ---------------------------------------------------------------------------
# Product-API Assignment — attach demo-users-api to Bronze product
# ---------------------------------------------------------------------------
resource "azurerm_api_management_product_api" "bronze_demo_users" {
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  product_id          = azurerm_api_management_product.bronze.product_id
  api_name            = azurerm_api_management_api.demo_users.name
}

# ---------------------------------------------------------------------------
# Backend Service — define the backend URL for the demo API
# ---------------------------------------------------------------------------
resource "azurerm_api_management_backend" "demo_users_backend" {
  name                = "demo-users-backend"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  protocol            = "http"
  url                 = var.backend_url
}
