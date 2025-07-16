# ------------------------------------------------------------------------------
# ACA Environment.
# ------------------------------------------------------------------------------
resource "azurerm_container_app_environment" "mcshared" {
  name                = "${local.project}-cae"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name

  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.core.id
  infrastructure_subnet_id       = azurerm_subnet.subnet_mcshared_cae.id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = var.aca_env_zones_enabled

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 0
  }

  tags = local.tags

  depends_on = [
    azurerm_subnet.aca
  ]

  lifecycle {
    ignore_changes = [
      infrastructure_resource_group_name
    ]
  }
}

resource "azurerm_private_endpoint" "private_endpoint_mcshared_cae" {
  name                = azurerm_container_app_environment.mcshared.name
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  subnet_id           = data.azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = azurerm_container_app_environment.mcshared.name
    private_connection_resource_id = azurerm_container_app_environment.mcshared.id
    is_manual_connection           = false
    subresource_names              = ["managedEnvironments"]
  }

  private_dns_zone_group {
    name                 = "${local.project}-cae"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.container_app.id]
  }
}
