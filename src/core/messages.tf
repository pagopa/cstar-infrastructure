resource "azurerm_resource_group" "msg_rg" {
  name     = format("%s-msg-rg", local.project)
  location = var.location

  tags = var.tags
}


module "event_hub" {
  source                   = "git::https://github.com/pagopa/azurerm.git//eventhub?ref=v4.13.2"
  name                     = format("%s-evh-ns", local.project)
  location                 = var.location
  resource_group_name      = azurerm_resource_group.msg_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units
  zone_redundant           = var.ehns_zone_redundant

  virtual_network_ids = [module.vnet_integration.id, module.vnet.id]
  subnet_id           = module.eventhub_snet.id

  eventhubs = var.eventhubs

  alerts_enabled = var.ehns_alerts_enabled
  metric_alerts  = var.ehns_metric_alerts
  action = [
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]

  network_rulesets = var.env_short == "d" ? [
    {
      default_action                 = "Deny"
      trusted_service_access_enabled = true
      virtual_network_rule = flatten([
        [
          {
            subnet_id                                       = module.eventhub_snet.id
            ignore_missing_virtual_network_service_endpoint = false
          },
          {
            subnet_id                                       = module.adf_snet[0].id
            ignore_missing_virtual_network_service_endpoint = false
          },
          {
            subnet_id                                       = module.k8s_snet.id
            ignore_missing_virtual_network_service_endpoint = false
          },
          {
            subnet_id                                       = module.private_endpoint_snet[0].id
            ignore_missing_virtual_network_service_endpoint = false
          },
        ],
        [
          for snet in data.azurerm_subnet.aks_domain_subnet : {
            subnet_id                                       = snet.id
            ignore_missing_virtual_network_service_endpoint = false
          }
        ]
      ])
      ip_rule = []
    }
  ] : []

  tags = var.tags
}

## Private endpoint to cstar-d-vnet to enable access from VPN
resource "azurerm_private_endpoint" "evh-cstar-vnet-private-endpoint" {
  # disabled in PROD
  count               = var.env_short == "p" ? 0 : 1
  name                = format("%s-evh-private-endpoint", local.project)
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  subnet_id           = module.private_endpoint_snet[0].id

  private_dns_zone_group {
    name = data.azurerm_private_dns_zone.eventhub_private_dns_zone.name
    private_dns_zone_ids = [
      data.azurerm_private_dns_zone.eventhub_private_dns_zone.id
    ]
  }

  private_service_connection {
    name                           = format("%s-evh-private-service-connection", local.project)
    is_manual_connection           = false
    private_connection_resource_id = module.event_hub.namespace_id
    subresource_names              = ["namespace"]
  }
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_keys" {
  for_each = module.event_hub.key_ids

  name         = format("evh-%s-%s", replace(each.key, ".", "-"), "key")
  value        = module.event_hub.keys[each.key].primary_key
  content_type = "text/plain"

  key_vault_id = module.key_vault.id
}

module "event_hub_fa_01" {
  source = "git::https://github.com/pagopa/azurerm.git//eventhub?ref=v1.0.70"


  name                     = format("%s-evh-ns-fa-01", local.project)
  location                 = var.location
  resource_group_name      = azurerm_resource_group.msg_rg.name
  auto_inflate_enabled     = var.ehns_auto_inflate_enabled
  sku                      = var.ehns_sku_name
  capacity                 = var.ehns_capacity
  maximum_throughput_units = var.ehns_maximum_throughput_units
  zone_redundant           = var.ehns_zone_redundant

  virtual_network_ids = [
    module.vnet_integration.id, module.vnet.id
  ]
  subnet_id = module.eventhub_snet.id

  private_dns_zones              = module.event_hub.private_dns_zone
  private_dns_zone_record_A_name = "eventhubfa01"

  eventhubs = var.eventhubs_fa

  alerts_enabled = var.ehns_alerts_enabled
  metric_alerts  = var.ehns_metric_alerts
  action = [
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]

  tags = var.tags
}

#tfsec:ignore:AZU023
resource "azurerm_key_vault_secret" "event_hub_keys_fa_01" {
  for_each = module.event_hub_fa_01.key_ids

  name         = format("evh-%s-%s-fa-01", replace(each.key, ".", "-"), "key")
  value        = module.event_hub_fa_01.keys[each.key].primary_key
  content_type = "text/plain"

  key_vault_id = module.key_vault.id
}
