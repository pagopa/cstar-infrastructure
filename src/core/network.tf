resource "azurerm_resource_group" "rg_vnet" {
  name     = "${local.project}-vnet-rg"
  location = var.location

  tags = var.tags
}

# MAIN VNET
module "vnet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v6.2.1"
  name                 = format("%s-vnet", local.project)
  location             = azurerm_resource_group.rg_vnet.location
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  address_space        = var.cidr_vnet
  ddos_protection_plan = var.ddos_protection_plan

  tags = var.tags
}

## Database subnet
module "db_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-db-snet", local.project)
  address_prefixes                          = var.cidr_subnet_db
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  service_endpoints                         = ["Microsoft.Sql"]
  private_endpoint_network_policies_enabled = false
}

module "cosmos_mongodb_snet" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                 = format("%s-cosmos-mongodb-snet", local.project)
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_cosmos_mongodb

  private_endpoint_network_policies_enabled = false
  service_endpoints                         = ["Microsoft.Web"]
}

module "private_endpoint_snet" {
  count = var.enable.core.private_endpoints_subnet ? 1 : 0

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                 = "private-endpoint-snet"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_private_endpoint

  private_endpoint_network_policies_enabled = false
  service_endpoints = [
    "Microsoft.Web", "Microsoft.AzureCosmosDB", "Microsoft.EventHub"
  ]
}

module "redis_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  count                = var.redis_sku_name == "Premium" && length(var.cidr_subnet_redis) > 0 ? 1 : 0
  name                 = format("%s-redis-snet", local.project)
  address_prefixes     = var.cidr_subnet_redis
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
}

# k8s cluster subnet
module "k8s_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-k8s-snet", local.project)
  address_prefixes                          = var.cidr_subnet_k8s
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = false

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage",
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub"
  ]
}

## Subnet jumpbox
module "jumpbox_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-jumpbox-snet", local.project)
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  address_prefixes                          = var.cidr_subnet_jumpbox
  private_endpoint_network_policies_enabled = true

}

module "azdoa_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  count                                     = var.enable_azdoa ? 1 : 0
  name                                      = format("%s-azdoa-snet", local.project)
  address_prefixes                          = var.cidr_subnet_azdoa
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = false
}

# Subnet to host the application gateway
module "appgateway-snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-appgateway-snet", local.project)
  address_prefixes                          = var.cidr_subnet_appgateway
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = true
}

# vnet integration
module "vnet_integration" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v6.2.1"
  name                 = format("%s-integration-vnet", local.project)
  location             = azurerm_resource_group.rg_vnet.location
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  address_space        = var.cidr_integration_vnet
  ddos_protection_plan = var.ddos_protection_plan

  tags = var.tags
}

# APIM subnet
module "apim_snet" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                 = format("%s-apim-snet", local.project)
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet_integration.name
  address_prefixes     = var.cidr_subnet_apim

  service_endpoints = ["Microsoft.Web", "Microsoft.Storage"]

  private_endpoint_network_policies_enabled = false
}

## Eventhub subnet
module "eventhub_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-eventhub-snet", local.project)
  address_prefixes                          = var.cidr_subnet_eventhub
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet_integration.name
  service_endpoints                         = ["Microsoft.EventHub"]
  private_endpoint_network_policies_enabled = false
}

# Subnet for Azure Data Factory
module "adf_snet" {

  count = var.enable.tae.adf ? 1 : 0


  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-adf-snet", local.project)
  address_prefixes                          = var.cidr_subnet_adf
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  private_endpoint_network_policies_enabled = false

  service_endpoints = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.EventHub"
  ]
}

## Peering between the vnet(main) and integration vnet
module "vnet_peering" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.2.1"

  location = azurerm_resource_group.rg_vnet.location

  source_resource_group_name       = azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = module.vnet.name
  source_remote_virtual_network_id = module.vnet.id
  source_allow_gateway_transit     = true
  # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet_integration.name
  target_remote_virtual_network_id = module.vnet_integration.id
  target_use_remote_gateways       = false # needed by vnet peering with SIA
}


## Application gateway public ip ##
resource "azurerm_public_ip" "appgateway_public_ip" {
  name                = format("%s-appgateway-maz-pip", local.project)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  // availability_zone   = var.app_gateway_public_ip_availability_zone
  zones = [1, 2, 3]

  tags = var.tags
}


# new application gateway multi az
module "app_gw_maz" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//app_gateway?ref=v6.2.1"

  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  name                = format("%s-app-gw-maz", local.project)

  # SKU
  sku_name = var.app_gateway_sku_name
  sku_tier = var.app_gateway_sku_tier

  # WAF
  waf_enabled = var.app_gateway_waf_enabled
  waf_disabled_rule_group = [
    {
      rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
      rules           = ["920300", ]
    }
  ]

  # Networking
  subnet_id    = module.appgateway-snet.id
  public_ip_id = azurerm_public_ip.appgateway_public_ip.id
  zones        = [1, 2, 3]

  # Configure backends
  backends = {
    apim = {
      protocol                    = "Https"
      host                        = trim(azurerm_dns_a_record.dns_a_appgw_api.fqdn, ".")
      port                        = 443
      ip_addresses                = module.apim.private_ip_addresses
      fqdns                       = [azurerm_dns_a_record.dns_a_appgw_api.fqdn]
      probe                       = "/status-0123456789abcdef"
      probe_name                  = "probe-apim"
      request_timeout             = 60
      pick_host_name_from_backend = false
    }

    portal = {
      protocol     = "Https"
      host         = trim(azurerm_dns_a_record.dns_a_apim_dev_portal.fqdn, ".")
      port         = 443
      ip_addresses = module.apim.private_ip_addresses
      fqdns = [
        azurerm_dns_a_record.dns_a_apim_dev_portal.fqdn
      ]
      probe                       = "/signin"
      probe_name                  = "probe-portal"
      request_timeout             = 60
      pick_host_name_from_backend = false
    }

    management = {
      protocol     = "Https"
      host         = trim(azurerm_dns_a_record.dns-a-managementcstar.fqdn, ".")
      port         = 443
      ip_addresses = module.apim.private_ip_addresses
      fqdns = [
        azurerm_dns_a_record.dns-a-managementcstar.fqdn
      ]
      probe                       = "/ServiceStatus"
      probe_name                  = "probe-management"
      request_timeout             = 60
      pick_host_name_from_backend = false
    }
  }

  ssl_profiles = [
    {
      name = format("%s-issuer-mauth-profile", local.project)
      trusted_client_certificate_names = [
        format("%s-issuer-chain", local.project)
      ]
      verify_client_cert_issuer_dn = true
      ssl_policy = {
        disabled_protocols = []
        policy_type        = "Custom"
        policy_name        = ""
        # with Custom type set empty policy_name (not required by the provider)
        cipher_suites = [
          "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
          "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
          "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
          "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA"
        ]
        min_protocol_version = "TLSv1_2"
      }
    }
  ]

  trusted_client_certificates = [
    {
      secret_name  = format("cstar-%s-issuer-chain", var.env_short)
      key_vault_id = module.key_vault.id
    }
  ]

  # Configure listeners
  listeners = {
    app_io = {
      protocol           = "Https"
      host               = format("api-io.%s.%s", var.dns_zone_prefix, var.external_domain)
      port               = 443
      ssl_profile_name   = null
      firewall_policy_id = null

      certificate = {
        name = var.app_gateway_api_io_certificate_name
        id = trimsuffix(
          data.azurerm_key_vault_certificate.app_gw_io_cstar[0].secret_id,
          data.azurerm_key_vault_certificate.app_gw_io_cstar[0].version
        )
      }
    }

    issuer_acquirer = {
      protocol           = "Https"
      host               = format("api.%s.%s", var.dns_zone_prefix, var.external_domain)
      port               = 443
      ssl_profile_name   = format("%s-issuer-mauth-profile", local.project)
      firewall_policy_id = null

      certificate = {
        name = var.app_gateway_api_certificate_name
        id = trimsuffix(
          data.azurerm_key_vault_certificate.app_gw_cstar.secret_id,
          data.azurerm_key_vault_certificate.app_gw_cstar.version
        )
      }
    }

    portal = {
      protocol           = "Https"
      host               = format("portal.%s.%s", var.dns_zone_prefix, var.external_domain)
      port               = 443
      ssl_profile_name   = null
      firewall_policy_id = null

      certificate = {
        name = var.app_gateway_portal_certificate_name
        id = trimsuffix(
          data.azurerm_key_vault_certificate.portal_cstar.secret_id,
          data.azurerm_key_vault_certificate.portal_cstar.version
        )
      }
    }

    management = {
      protocol           = "Https"
      host               = format("management.%s.%s", var.dns_zone_prefix, var.external_domain)
      port               = 443
      ssl_profile_name   = null
      firewall_policy_id = null

      certificate = {
        name = var.app_gateway_management_certificate_name
        id = trimsuffix(
          data.azurerm_key_vault_certificate.management_cstar.secret_id,
          data.azurerm_key_vault_certificate.management_cstar.version
        )
      }
    }
  }

  # maps listener to backend
  routes = {

    api = {
      listener              = "app_io"
      backend               = "apim"
      rewrite_rule_set_name = null
      priority              = 10

    }

    broker = {
      listener              = "issuer_acquirer"
      backend               = "apim"
      rewrite_rule_set_name = "rewrite-rule-set-broker-api"
      priority              = 30

    }

    portal = {
      listener              = "portal"
      backend               = "portal"
      priority              = 20
      rewrite_rule_set_name = null
    }

    mangement = {
      listener              = "management"
      backend               = "management"
      rewrite_rule_set_name = null
      priority              = 40

    }
  }

  rewrite_rule_sets = [
    {
      name = "rewrite-rule-set-broker-api"
      rewrite_rules = [{
        name          = "mauth-headers"
        rule_sequence = 100
        conditions    = []
        request_header_configurations = [
          {
            header_name  = "X-Client-Certificate-Verification"
            header_value = "{var_client_certificate_verification}"
          },
          {
            header_name  = "X-Client-Certificate-End-Date"
            header_value = "{var_client_certificate_end_date}"
          }
        ]
        response_header_configurations = []
        url                            = null
      }]
    },
  ]

  # TLS
  identity_ids = [azurerm_user_assigned_identity.appgateway.id]

  # Scaling
  app_gateway_min_capacity = var.app_gateway_min_capacity
  app_gateway_max_capacity = var.app_gateway_max_capacity

  alerts_enabled = var.app_gateway_alerts_enabled

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

  # metrics docs
  # https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftnetworkapplicationgateways
  monitor_metric_alert_criteria = {

    compute_units_usage = {
      description   = "Abnormal compute units usage, probably an high traffic peak"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 2
      auto_mitigate = true

      criteria = []
      dynamic_criteria = [
        {
          aggregation       = "Average"
          metric_name       = "ComputeUnits"
          operator          = "GreaterOrLessThan"
          alert_sensitivity = "Low"
          # todo after api app migration change to High
          evaluation_total_count   = 2
          evaluation_failure_count = 2
          dimension                = []
        }
      ]
    }

    backend_pools_status = {
      description   = "One or more backend pools are down, check Backend Health on Azure portal"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 0
      auto_mitigate = true

      criteria = [
        {
          aggregation = "Average"
          metric_name = "UnhealthyHostCount"
          operator    = "GreaterThan"
          threshold   = 0
          dimension   = []
        }
      ]
      dynamic_criteria = []
    }

    total_requests = {
      description   = "Traffic is raising"
      frequency     = "PT5M"
      window_size   = "PT15M"
      severity      = 3
      auto_mitigate = true

      criteria = []
      dynamic_criteria = [
        {
          aggregation              = "Total"
          metric_name              = "TotalRequests"
          operator                 = "GreaterThan"
          alert_sensitivity        = "Medium"
          evaluation_total_count   = 1
          evaluation_failure_count = 1
          dimension                = []
        }
      ]
    }

    failed_requests = {
      description   = "Abnormal failed requests"
      frequency     = "PT5M"
      window_size   = "PT5M"
      severity      = 1
      auto_mitigate = true

      criteria = []
      dynamic_criteria = [
        {
          aggregation              = "Total"
          metric_name              = "FailedRequests"
          operator                 = "GreaterThan"
          alert_sensitivity        = "Medium"
          evaluation_total_count   = 2
          evaluation_failure_count = 2
          dimension                = []
        }
      ]
    }

  }

  tags = var.tags
}


resource "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  name                = format("%s-aksoutbound-pip-%02d", local.project, count.index + 1)
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"

  zones = [1, 2, 3]

  tags = var.tags
}

module "route_table_peering_sia" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//route_table?ref=v6.2.1"

  name                          = format("%s-sia-rt", local.project)
  location                      = azurerm_resource_group.rg_vnet.location
  resource_group_name           = azurerm_resource_group.rg_vnet.name
  disable_bgp_route_propagation = false

  subnet_ids = [module.apim_snet.id, module.eventhub_snet.id]

  routes = [
    {
      # production
      name                   = "to-sia-prod-subnet"
      address_prefix         = "10.70.132.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-sia-uat-subnet"
      address_prefix         = "10.70.67.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-apim-sia-uat-subnet"
      address_prefix         = "10.70.65.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # prod
      name                   = "to-apim-sia-prod-subnet"
      address_prefix         = "10.70.133.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # prod
      name                   = "to-haproxy-sia-prod-subnet"
      address_prefix         = "10.70.131.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # dev
      name                   = "to-aks-nexi-dev-subnet"
      address_prefix         = "10.70.66.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # dev
      name                   = "to-payment-manager-nexi-dev-subnet"
      address_prefix         = "10.70.68.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-aks-nexi-uat-subnet"
      address_prefix         = "10.70.74.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-payment-manager-nexi-uat-subnet"
      address_prefix         = "10.70.72.0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
    {
      # uat
      name                   = "to-blob-pci-nexi-uat-subnet"
      address_prefix         = "10.70.73.32/27"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.70.249.10"
    },
  ]

  tags = var.tags
}

# Postgres Flexible Server subnet
module "postgres_flexible_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-pgres-flexible-snet", local.project)
  address_prefixes                          = var.cidr_subnet_flex_dbms
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  service_endpoints                         = ["Microsoft.Storage"]
  private_endpoint_network_policies_enabled = false

  delegation = {
    name = "delegation"
    service_delegation = {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Azure Blob Storage subnet
module "storage_account_snet" {
  source                                    = "git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet?ref=v6.2.1"
  name                                      = format("%s-storage-account-snet", local.project)
  address_prefixes                          = var.cidr_subnet_storage_account
  resource_group_name                       = azurerm_resource_group.rg_vnet.name
  virtual_network_name                      = module.vnet.name
  service_endpoints                         = ["Microsoft.Storage"]
  private_endpoint_network_policies_enabled = false
}

resource "azurerm_private_endpoint" "blob_storage_pe" {
  name                = format("%s-blob-storage-pe", local.project)
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
  subnet_id           = module.storage_account_snet.id

  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.storage_account.name
    private_dns_zone_ids = [azurerm_private_dns_zone.storage_account.id]
  }
  private_service_connection {
    name                           = format("%s-blob-storage-private-service-connection", local.project)
    is_manual_connection           = false
    private_connection_resource_id = module.cstarblobstorage.id
    subresource_names              = ["blob"]
  }

}
