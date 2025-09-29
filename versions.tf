terraform {
required_version = ">= 1.6.0"
required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = ">= 3.116.0"
}
random = {
source = "hashicorp/random"
version = ">= 3.6.0"
}
}
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}