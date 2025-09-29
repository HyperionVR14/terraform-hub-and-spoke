resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location
}

# --- Networks (Hub + Spokes) ---
module "vnet_hub" {
  source              = "./modules/network"
  name                = "${var.name_prefix}-hub-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.hub_address_space
  subnet_name         = "snet-hub"
}

module "vnet_spoke1" {
  source              = "./modules/network"
  name                = "${var.name_prefix}-spoke1-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.spoke1_address_space
  subnet_name         = "snet-spoke1"
}

module "vnet_spoke2" {
  source              = "./modules/network"
  name                = "${var.name_prefix}-spoke2-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.spoke2_address_space
  subnet_name         = "snet-spoke2"
}

# --- Peerings ---
module "peer_hub_spoke1" {
  source              = "./modules/peering"
  resource_group_name = azurerm_resource_group.rg.name

  vnet1_name = module.vnet_hub.vnet_name
  vnet1_id   = module.vnet_hub.vnet_id
  vnet2_name = module.vnet_spoke1.vnet_name
  vnet2_id   = module.vnet_spoke1.vnet_id
}

module "peer_hub_spoke2" {
  source              = "./modules/peering"
  resource_group_name = azurerm_resource_group.rg.name

  vnet1_name = module.vnet_hub.vnet_name
  vnet1_id   = module.vnet_hub.vnet_id
  vnet2_name = module.vnet_spoke2.vnet_name
  vnet2_id   = module.vnet_spoke2.vnet_id
}

# --- Storage Account (private only) + Private Endpoint + Private DNS ---
module "storage" {
  source              = "./modules/storage"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_id             = module.vnet_hub.vnet_id
  subnet_id           = module.vnet_hub.subnet_id

vnet_links = {
  hub    = module.vnet_hub.vnet_id
  spoke1 = module.vnet_spoke1.vnet_id
  spoke2 = module.vnet_spoke2.vnet_id
}
}

# --- Key Vault (private only) + Private Endpoint + Private DNS ---
module "keyvault" {
  source              = "./modules/keyvault"
  name_prefix         = var.name_prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_id             = module.vnet_hub.vnet_id
  subnet_id           = module.vnet_hub.subnet_id

vnet_links = {
  hub    = module.vnet_hub.vnet_id
  spoke1 = module.vnet_spoke1.vnet_id
  spoke2 = module.vnet_spoke2.vnet_id
}
}

# --- VM (Linux, private IP only) ---
module "vm_hub" {
  source              = "./modules/vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name_prefix         = var.name_prefix
  subnet_id           = module.vnet_hub.subnet_id
  admin_username = var.admin_username
  ssh_public_key = file(var.ssh_public_key)
}