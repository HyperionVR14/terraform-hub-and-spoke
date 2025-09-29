resource "azurerm_virtual_network" "this" {
name = var.name
resource_group_name = var.resource_group_name
location = var.location
address_space = var.address_space
}


# NSG: deny inbound from Internet, allow VNet-internal
resource "azurerm_network_security_group" "this" {
name = "${var.name}-nsg"
location = var.location
resource_group_name = var.resource_group_name


security_rule {
name = "allow-vnet-inbound"
priority = 100
direction = "Inbound"
access = "Allow"
protocol = "*"
source_port_range = "*"
destination_port_range = "*"
source_address_prefix = "VirtualNetwork"
destination_address_prefix = "VirtualNetwork"
}


security_rule {
name = "deny-internet-inbound"
priority = 200
direction = "Inbound"
access = "Deny"
protocol = "*"
source_port_range = "*"
destination_port_range = "*"
source_address_prefix = "Internet"
destination_address_prefix = "*"
}
}


resource "azurerm_subnet" "this" {
name = var.subnet_name
resource_group_name = var.resource_group_name
virtual_network_name = azurerm_virtual_network.this.name
address_prefixes = [cidrsubnet(var.address_space[0], 8, 1)]
}


resource "azurerm_subnet_network_security_group_association" "assoc" {
subnet_id = azurerm_subnet.this.id
network_security_group_id = azurerm_network_security_group.this.id
}