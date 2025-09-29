output "vnet_id" { value = azurerm_virtual_network.this.id }
output "vnet_name" { value = azurerm_virtual_network.this.name }
output "address_space" { value = azurerm_virtual_network.this.address_space }
output "subnet_id" { value = azurerm_subnet.this.id }