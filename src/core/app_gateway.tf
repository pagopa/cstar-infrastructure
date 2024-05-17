module "app_gw_maz" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//app_gateway?ref=v8.13.0"

  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  name                = "${local.project}-app-gw-maz"

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
      name = "${local.project}-issuer-mauth-profile"
      trusted_client_certificate_names = [
        "${local.project}-issuer-chain"
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
      secret_name  = "cstar-${var.env_short}-issuer-chain"
      key_vault_id = module.key_vault.id
    }
  ]

  # Configure listeners
  listeners = {
    app_io = {
      protocol           = "Https"
      host               = "api-io.${var.dns_zone_prefix}.${var.external_domain}"
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
      host               = "api.${var.dns_zone_prefix}.${var.external_domain}"
      port               = 443
      ssl_profile_name   = "${local.project}-issuer-mauth-profile"
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
      host               = "portal.${var.dns_zone_prefix}.${var.external_domain}"
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
      host               = "management.${var.dns_zone_prefix}.${var.external_domain}"
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
        },
        {
          name          = "remove-tracing-headers"
          rule_sequence = 10
          conditions    = []
          request_header_configurations = [
            {
              header_name  = "Ocp-Apim-Trace"
              header_value = ""
            }
          ]
          response_header_configurations = [
            {
              header_name  = "Ocp-Apim-Trace-Location"
              header_value = ""
            }
          ]
          url = null
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
      action_group_id    = azurerm_monitor_action_group.core_send_to_opsgenie.id # Opsgenie
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
      severity      = 4
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
      severity      = 4
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
