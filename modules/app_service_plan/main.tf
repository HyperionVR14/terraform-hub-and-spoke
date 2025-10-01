terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_service_plan" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name   # напр. "P1v3" или "B1" за тест
  zone_balancing_enabled = var.zone_balancing_enabled
  tags                = var.tags
}

output "id" {
  value = azurerm_service_plan.this.id
}
output "name" {
  value = azurerm_service_plan.this.name
}
