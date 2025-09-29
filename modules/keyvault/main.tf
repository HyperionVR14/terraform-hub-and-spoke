resource "random_string" "kv" { 
    length = 4 
    special = false 
    upper = false 
    }

resource "azurerm_key_vault" "this" {
name = "${var.name_prefix}-kv-${random_string.kv.result}"
location = var.location
resource_group_name = var.resource_group_name
tenant_id = data.azurerm_client_config.current.tenant_id
sku_name = "standard"
soft_delete_retention_days = 7
purge_protection_enabled = false
public_network_access_enabled = false


network_acls {
default_action = "Deny"
bypass = "AzureServices"
}
}


data "azurerm_client_config" "current" {}


# Private DNS for vault
resource "azurerm_private_dns_zone" "vault" {
name = "privatelink.vaultcore.azure.net"
resource_group_name = var.resource_group_name
}


resource "azurerm_private_dns_zone_virtual_network_link" "vault_links" {
  for_each              = var.vnet_links
  name                  = "link-${each.key}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.vault.name
  virtual_network_id    = each.value
  registration_enabled  = false
}


resource "azurerm_private_endpoint" "vault" {
name = "${var.name_prefix}-kv-pe"
location = var.location
resource_group_name = var.resource_group_name
subnet_id = var.subnet_id


private_service_connection {
name = "kv-conn"
private_connection_resource_id = azurerm_key_vault.this.id
subresource_names = ["vault"]
is_manual_connection = false
}


private_dns_zone_group {
name = "vault-dns"
private_dns_zone_ids = [azurerm_private_dns_zone.vault.id]
}
}