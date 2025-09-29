resource "random_string" "sa" { 
    length = 6 
    special = false 
    upper = false 
    }


resource "azurerm_storage_account" "this" {
name = replace("${var.name_prefix}sa${random_string.sa.result}", "-", "")
resource_group_name = var.resource_group_name
location = var.location
account_tier = "Standard"
account_replication_type = "LRS"
min_tls_version = "TLS1_2"


public_network_access_enabled = false
network_rules {
default_action = "Deny"
bypass = ["AzureServices"]
}
}


# Private DNS zone for Blob
resource "azurerm_private_dns_zone" "blob" {
name = "privatelink.blob.core.windows.net"
resource_group_name = var.resource_group_name
}


# Link all VNets to the zone
resource "azurerm_private_dns_zone_virtual_network_link" "blob_links" {
  for_each              = var.vnet_links
  name                  = "link-${each.key}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = each.value
  registration_enabled  = false
}


# Private Endpoint for blob
resource "azurerm_private_endpoint" "blob" {
name = "${var.name_prefix}-sa-pe"
location = var.location
resource_group_name = var.resource_group_name
subnet_id = var.subnet_id


private_service_connection {
name = "sa-blob-conn"
private_connection_resource_id = azurerm_storage_account.this.id
subresource_names = ["blob"]
is_manual_connection = false
}


private_dns_zone_group {
name = "blob-dns"
private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
}
}