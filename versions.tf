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
  features {
        resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
variable "allow_rg_destroy" {
  type    = bool
  default = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location

  lifecycle {
    prevent_destroy = var.allow_rg_destroy ? false : true
  }
}