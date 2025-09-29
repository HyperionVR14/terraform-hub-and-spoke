terraform {
  
  #Remote backend to azure in different resource group

  backend "azurerm" {
    resource_group_name  = "RG-Lab"
    storage_account_name = "kristiyansterraform"
    container_name       = "terraform-hub"
    key                  = "terraform.terraform-hub"
  }
}