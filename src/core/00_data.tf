data "azurerm_virtual_network" "securehub_hub" {
  name                = local.vnet_securehub_core_hub_name
  resource_group_name = local.vnet_securehub_rg_name
}

data "azurerm_resources" "vnets" {
  type = "Microsoft.Network/virtualNetworks"
}

data "azurerm_resources" "vnets_secure_hub" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = local.vnet_securehub_rg_name
}

data "azurerm_key_vault_secret" "alert_cert_pipeline_status_notification_slack" {
  name         = "alert-cert-pipeline-status-notification-slack"
  key_vault_id = module.key_vault.id
}
