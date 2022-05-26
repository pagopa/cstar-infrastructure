resource "azurerm_resource_group" "container_registry_platform" {
  name     = local.resource_group_container_registry_platform_name
  location = var.location

  tags = var.tags
}


module "container_registry_platform" {
  source = "git::https://github.com/pagopa/azurerm.git//container_registry?ref=v2.16.0"

  name                          = replace(local.container_registry_platform_name, "-", "")
  location                      = var.location
  resource_group_name           = azurerm_resource_group.container_registry_platform.name
  sku                           = var.env_short == "p" ? "Premium" : "Basic"
  admin_enabled                 = false
  anonymous_pull_enabled        = false
  zone_redundancy_enabled       = var.env_short == "p" ? true : false
  public_network_access_enabled = true

  private_endpoint = {
    enabled              = false
    private_dns_zone_ids = null
    subnet_id            = ""
    virtual_network_id   = ""
  }

  georeplications = var.env_short == "p" ? [{
    location                  = var.location_pair
    regional_endpoint_enabled = false
    zone_redundancy_enabled   = true
  }] : []

  tags = var.tags
}
