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
  ssh_public_key = var.ssh_public_key
}
module "app_service_plan" {
  source              = "./modules/app_service_plan"
  name                = "${var.name_prefix}-asp"
  resource_group_name = azurerm_resource_group.rg.name  
  location            = var.location

  # За dev може B1; за по-сериозно – P1v3
  sku_name                  = var.asp_sku_name   # напр. "B1" или "P1v3"
  zone_balancing_enabled    = false

}

########################################
# Web App (+ опционално VNet Integration и Private Endpoint)
########################################
module "web_app" {
  source              = "./modules/web_app"
  name                = "${var.name_prefix}-web"
  resource_group_name = azurerm_resource_group.rg.name  
  location            = var.location

  app_service_plan_id = module.app_service_plan.id

  # Outbound VNet Integration (делегирана подсмрежа Microsoft.Web/serverFarms)
  #vnet_integration_subnet_id = var.snet_app_integration_id    # или null ако няма още

  # Private Endpoint подсмрежа (НЕделегирана)
  #private_endpoint_subnet_id = var.snet_private_endpoints_id   # или null за фаза 1

  # Private DNS за privatelink.azurewebsites.net
  create_private_dns = true
  dns_link_vnet_ids  = [
  ]

  # Bootstrap: позволи публичен достъп за първоначален деплой на HTML
  public_access_enabled = true  # фаза 1 → след това го правиш false (deny-all)

  app_settings = {
    "APP_ENV" = "dev"
  }
}
#change