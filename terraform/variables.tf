variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "container_registry_name" {
  description = "Container registry name"
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault name"
  type        = string
}