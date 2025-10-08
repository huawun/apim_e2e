output "app_registration_client_id" {
  value = azuread_application.main.application_id
}

output "app_service_url" {
  value = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "api_management_url" {
  value = "https://${azurerm_api_management.main.gateway_url}"
}

output "container_registry_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "key_vault_url" {
  value = azurerm_key_vault.main.vault_uri
}