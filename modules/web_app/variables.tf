variable "name" {
  type        = string
  description = "Web App name"
}

variable "resource_group_name" {
  type        = string
  description = "Target Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "app_service_plan_id" {
  type        = string
  description = "Service Plan (App Service Plan) ID"
}

variable "app_settings" {
  type        = map(string)
  default     = {}
  description = "Key/Value app settings for the Web App"
}

variable "vnet_integration_subnet_id" {
  type        = string
  default     = null
  description = "Delegated subnet ID for VNet Integration (optional)"
}

variable "private_endpoint_subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID for Private Endpoint (optional)"
}

variable "create_private_dns" {
  type        = bool
  default     = true
  description = "If true, create Private DNS zone privatelink.azurewebsites.net in this module"
}

variable "dns_link_vnet_ids" {
  type        = list(string)
  default     = []
  description = "VNet IDs to link to the created Private DNS zone"
}

variable "private_dns_zone_ids_app" {
  type        = list(string)
  default     = []
  description = "Existing Private DNS zone IDs for privatelink.azurewebsites.net (used when create_private_dns = false)"
}

variable "public_access_enabled" {
  type        = bool
  default     = true
  description = "Allow public access during bootstrap; set false to deny-all via IP restrictions"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}