resource "azurerm_linux_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id
  https_only          = true

  identity { type = "SystemAssigned" }

  site_config {
    ftps_state = "Disabled"

    application_stack {
      node_version = "20-lts"
    }

    dynamic "ip_restriction" {
      for_each = var.public_access_enabled ? [] : [1]
      content {
        name     = "deny-all"
        priority = 65500
        action   = "Deny"
        ip_address = "0.0.0.0/0"
      }
    }
  }

  app_settings = merge({
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
  }, var.app_settings)

  tags = var.tags
}

# VNet Integration (ако не ползваш top-level virtual_network_subnet_id)
resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  count          = var.vnet_integration_subnet_id == null ? 0 : 1
  app_service_id = azurerm_linux_web_app.this.id
  subnet_id      = var.vnet_integration_subnet_id
}

# Private DNS (по избор)
resource "azurerm_private_dns_zone" "app" {
  count               = var.create_private_dns ? 1 : 0
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
resource "azurerm_private_dns_zone_virtual_network_link" "app_links" {
  count                 = var.create_private_dns ? length(var.dns_link_vnet_ids) : 0
  name                  = "link-app-${count.index}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.app[0].name
  virtual_network_id    = var.dns_link_vnet_ids[count.index]
  registration_enabled  = false
  tags                  = var.tags
}

# Private Endpoint към Web App
resource "azurerm_private_endpoint" "app" {
  count               = var.private_endpoint_subnet_id == null ? 0 : 1
  name                = "${var.name}-pe"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_linux_web_app.this.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "app"
    private_dns_zone_ids = var.create_private_dns ? [azurerm_private_dns_zone.app[0].id] : var.private_dns_zone_ids_app
  }
}

