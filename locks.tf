variable "enable_rg_delete_lock" {
  type    = bool
  default = true  # по подразбиране защитено
}

resource "azurerm_management_lock" "rg_delete_lock" {
  count      = var.enable_rg_delete_lock ? 1 : 0
  name       = "rg-delete-lock"
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"
  notes      = "Prevent accidental deletes"
}