resource "azurerm_resource_group" "rg_container_registry_common" {
  name     = local.rg_container_registry_common_name
  location = var.location

  tags = var.tags
}


module "container_registry_common" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_registry?ref=v8.13.0"

  name                          = replace(local.container_registry_common_name, "-", "")
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg_container_registry_common.name
  sku                           = var.env_short == "p" ? "Premium" : "Basic"
  admin_enabled                 = false
  anonymous_pull_enabled        = false
  zone_redundancy_enabled       = var.env_short == "p" ? true : false
  public_network_access_enabled = true

  private_endpoint_enabled = false

  georeplications = var.env_short == "p" ? [{
    location                  = var.location_pair
    regional_endpoint_enabled = false
    zone_redundancy_enabled   = true
  }] : []

  network_rule_set = [{
    default_action  = "Allow"
    ip_rule         = []
    virtual_network = []
  }]

  tags = var.tags
}
