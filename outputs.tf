output "rg_name" { value = azurerm_resource_group.rg.name }


output "hub_vnet" {
value = {
name = module.vnet_hub.vnet_name
cidr = module.vnet_hub.address_space
subnet = module.vnet_hub.subnet_id
}
}


output "spokes" {
value = {
spoke1 = { name = module.vnet_spoke1.vnet_name, cidr = module.vnet_spoke1.address_space }
spoke2 = { name = module.vnet_spoke2.vnet_name, cidr = module.vnet_spoke2.address_space }
}
}


output "storage_account_name" { value = module.storage.account_name }
output "key_vault_name" { value = module.keyvault.kv_name }
output "vm_private_ip" { value = module.vm_hub.private_ip }