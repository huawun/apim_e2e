terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azurerm_client_config" "current" {}

# App Registration
resource "azuread_application" "main" {
  display_name = var.app_name
  owners       = [data.azurerm_client_config.current.object_id]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  web {
    redirect_uris = ["https://${var.app_name}.azurewebsites.net/.auth/login/aad/callback"]
  }
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
  owners         = [data.azurerm_client_config.current.object_id]
}

resource "azuread_application_password" "main" {
  application_object_id = azuread_application.main.object_id
  display_name          = "terraform-managed"
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
  }
}

resource "azurerm_key_vault_secret" "client_secret" {
  name         = "client-secret"
  value        = azuread_application_password.main.value
  key_vault_id = azurerm_key_vault.main.id
}

# Container Registry
resource "azurerm_container_registry" "main" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "asp-${var.app_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# App Service
resource "azurerm_linux_web_app" "main" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image     = "${azurerm_container_registry.main.login_server}/${var.app_name}"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.main.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.main.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.main.admin_password
    "AZURE_CLIENT_ID"                 = azuread_application.main.application_id
    "AZURE_TENANT_ID"                 = data.azurerm_client_config.current.tenant_id
    "KEY_VAULT_URL"                   = azurerm_key_vault.main.vault_uri
  }

  identity {
    type = "SystemAssigned"
  }
}

# Key Vault access for App Service
resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.main.identity[0].principal_id

  secret_permissions = ["Get", "List"]
}

# API Management
resource "azurerm_api_management" "main" {
  name                = "apim-${var.app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "API Publisher"
  publisher_email     = "admin@example.com"
  sku_name            = "Developer_1"
}

resource "azurerm_api_management_api" "main" {
  name                = "${var.app_name}-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "${var.app_name} API"
  path                = "api"
  protocols           = ["https"]
  service_url         = "https://${azurerm_linux_web_app.main.default_hostname}"

  import {
    content_format = "openapi+json"
    content_value = jsonencode({
      openapi = "3.0.0"
      info = {
        title   = "${var.app_name} API"
        version = "1.0.0"
      }
      paths = {
        "/health" = {
          get = {
            summary = "Health Check"
            responses = {
              "200" = {
                description = "OK"
              }
            }
          }
        }
      }
    })
  }
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "ai-${var.app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}