resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
name = "${var.vnet1_name}-to-${var.vnet2_name}"
resource_group_name = var.resource_group_name
virtual_network_name = var.vnet1_name
remote_virtual_network_id = var.vnet2_id
allow_forwarded_traffic = true
allow_gateway_transit = false
use_remote_gateways = false
}


resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
name = "${var.vnet2_name}-to-${var.vnet1_name}"
resource_group_name = var.resource_group_name
virtual_network_name = var.vnet2_name
remote_virtual_network_id = var.vnet1_id
allow_forwarded_traffic = true
allow_gateway_transit = false
use_remote_gateways = false
}