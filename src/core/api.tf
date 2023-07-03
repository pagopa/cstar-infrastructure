resource "azurerm_resource_group" "rg_api" {
  name     = format("%s-api-rg", local.project)
  location = var.location

  tags = var.tags
}

locals {
  apim_cert_name_proxy_endpoint   = format("%s-proxy-endpoint-cert", local.project)
  portal_cert_name_proxy_endpoint = format("%s-proxy-endpoint-cert", "portal")

  api_domain        = format("api.%s.%s", var.dns_zone_prefix, var.external_domain)
  portal_domain     = format("portal.%s.%s", var.dns_zone_prefix, var.external_domain)
  management_domain = format("management.%s.%s", var.dns_zone_prefix, var.external_domain)
}


###########################
## Api Management (apim) ##
###########################

module "apim" {

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management?ref=v6.2.1"
  subnet_id            = module.apim_snet.id
  location             = azurerm_resource_group.rg_api.location
  name                 = format("%s-apim", local.project)
  resource_group_name  = azurerm_resource_group.rg_api.name
  publisher_name       = var.apim_publisher_name
  publisher_email      = data.azurerm_key_vault_secret.apim_publisher_email.value
  sku_name             = var.apim_sku
  virtual_network_type = "Internal"

  # To enable external cache uncomment the following lines
  # redis_connection_string = module.redis.primary_connection_string
  # redis_cache_id          = module.redis.id

  redis_connection_string = null
  redis_cache_id          = null

  # This enables the Username and Password Identity Provider
  sign_up_enabled = true

  sign_up_terms_of_service = {
    consent_required = false
    enabled          = false
    text             = ""
  }

  application_insights = {
    enabled             = true
    instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
  }

  xml_content = templatefile("./api/base_policy.tpl", {
    portal-domain         = local.portal_domain
    management-api-domain = local.management_domain
    cors-global-only      = false # if true only global policy will check cors, otherwise other cors policy can be defined. (UAT for FA POC)
    apim-name             = format("%s-apim", local.project)
  })

  tags = var.tags

  depends_on = [
    azurerm_application_insights.application_insights
  ]
}

resource "azurerm_api_management_custom_domain" "api_custom_domain" {
  api_management_id = module.apim.id

  gateway {
    host_name = local.api_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.app_gw_cstar.secret_id,
      "/${data.azurerm_key_vault_certificate.app_gw_cstar.version}",
      ""
    )
  }

  gateway {
    host_name    = trimsuffix(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")
    key_vault_id = azurerm_key_vault_certificate.apim_internal_custom_domain_cert.versionless_secret_id
  }

  developer_portal {
    host_name = local.portal_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.portal_cstar.secret_id,
      "/${data.azurerm_key_vault_certificate.portal_cstar.version}",
      ""
    )
  }

  management {
    host_name = local.management_domain
    key_vault_id = replace(
      data.azurerm_key_vault_certificate.management_cstar.secret_id,
      "/${data.azurerm_key_vault_certificate.management_cstar.version}",
      ""
    )
  }

  depends_on = [
    azurerm_key_vault_certificate.apim_internal_custom_domain_cert
  ]
}

resource "azurerm_api_management_notification_recipient_email" "email_assistenza_on_new_subscription" {
  api_management_id = module.apim.id
  notification_type = "RequestPublisherNotificationMessage"
  email             = var.cstar_support_email
}

#########
## API ##
#########

## monitor ##
module "monitor" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = format("%s-monitor", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Monitor"
  display_name = "Monitor"
  path         = ""
  protocols    = ["https", "http"]

  service_url = null

  content_format = "openapi"
  content_value = templatefile("./api/monitor/openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "get"
      xml_content  = file("./api/monitor/mock_policy.xml")
    }
  ]
}

## BPD Info Privacy ##
module "api_bdp_info_privacy" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = format("%s-bpd-info-privacy", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD Info Privacy"
  path         = "cstar-bpd"
  protocols    = ["https", "http"]

  service_url = format("https://%s/%s",
    azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
    azurerm_storage_container.info_privacy.name
  )

  content_format = "openapi"
  content_value = templatefile("./api/bpd_info_privacy/openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/azureblob/azureblob_policy.xml")

  product_ids           = [module.bpd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "cstarinfoprivacy"
      xml_content  = file("./api/bpd_info_privacy/cstarinfoprivacy_policy.xml")
    }
  ]
}

module "api_bpd-io_payment_instrument" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-bpd-io-payment-instrument-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD IO Payment Instrument API"
  path         = "bpd/io/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_payment_instrument/swagger.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/bpd_io_payment_instrument/policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "enrollmentPaymentInstrumentIOUsingPUT",
      xml_content = templatefile("./api/bpd_io_payment_instrument/put_enrollment_payment_instrument_io_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "paymentinstrumentsnumber",
      xml_content  = file("./api/bpd_io_payment_instrument/get_paymentinstrumentsnumber_policy.xml")
    },
  ]
}

module "api_bpd_pm_payment_instrument" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-bpd-pm-payment-instrument", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD PM Payment Instrument"
  path         = "bpd/pm/payment-instrument"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_pm_payment_instrument/openapi.json", {
    host = local.apim_hostname # azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  # mock delete api only for dev and uat
  api_operation_policies = var.env_short == "d" || var.env_short == "u" ? [
    {
      operation_id = "delete"
      xml_content  = file("./api/bpd_pm_payment_instrument/mock_delete_policy.xml")
    }
  ] : []

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.pm_api_product.product_id]
  subscription_required = true
}

module "api_bpd_io_backend_test" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-bpd-io-backend-test-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "TEST IO Backend API server."
  display_name = "BPD IO Backend TEST API"
  path         = "bpd/pagopa/api/v1"
  protocols    = ["https", "http"]

  service_url = format("http://%s/cstariobackendtest/bpd/pagopa/api/v1", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_backend_test/swagger.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids = [module.bpd_api_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getToken",
      xml_content = templatefile("./api/bpd_io_backend_test/post_get_token_policy.xml", {
        reverse_proxy_ip = var.reverse_proxy_ip
      })
    },
  ]
}

module "api_bpd_tc" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"

  name                = format("%s-bpd-tc-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD TC API"
  path         = "bpd/tc"
  protocols    = ["https", "http"]

  service_url = format("https://%s/%s",
    azurerm_private_endpoint.blob_storage_pe.private_dns_zone_configs[0].record_sets[0].fqdn,
    azurerm_storage_container.bpd_terms_and_conditions.name
  )


  content_value = templatefile("./api/bpd_tc/swagger.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/azureblob/azureblob_policy.xml")

  product_ids = [module.bpd_api_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getTermsAndConditionsUsingGET",
      xml_content  = file("./api/bpd_tc/get_terms_and_conditions_html.xml")
    },
    {
      operation_id = "getTermsAndConditionsPDF",
      xml_content  = file("./api/bpd_tc/get_terms_and_conditions_pdf.xml")
    },
  ]
}

## 04 BPD IO Award Period API ##
resource "azurerm_api_management_api_version_set" "bpd_io_award_period" {
  name                = format("%s-bpd-io-award-period", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Award Period API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_award_period_original" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                 = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name  = module.apim.name
  resource_group_name  = azurerm_resource_group.rg_api.name
  version_set_id       = azurerm_api_management_api_version_set.bpd_io_award_period.id
  revision             = 2
  revision_description = "closing cashback"

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_award_period/original/swagger.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "findAllUsingGET"
      xml_content = templatefile("./api/bpd_io_award_period/original/findAllUsingGET_close_cashback_policy.xml", {
        env_short = var.env_short
      })
    }
  ]
}

### v2 ###
module "bpd_io_award_period_v2" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                 = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name  = module.apim.name
  resource_group_name  = azurerm_resource_group.rg_api.name
  version_set_id       = azurerm_api_management_api_version_set.bpd_io_award_period.id
  revision             = 2
  revision_description = "closing cashback"
  api_version          = "v2"

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_award_period/v2/openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "findAllUsingGET"
      xml_content = templatefile("./api/bpd_io_award_period/v2/findAllUsingGET_close_cashback_policy.xml", {
        env_short = var.env_short
      })
    }
  ]
}

## 05 BPD IO Citizen API ##
resource "azurerm_api_management_api_version_set" "bpd_io_citizen" {
  name                = format("%s-bpd-io-citizen", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Citizen API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_citizen_original" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = format("%s-bpd-io-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen.id

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_citizen/original/swagger.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/bpd_io_citizen/original/deleteUsingDELETE_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollment"
      xml_content = templatefile("./api/bpd_io_citizen/original/enrollment_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/bpd_io_citizen/original/findUsingGET_policy.xml")
    },
    {
      operation_id = "findRankingUsingGET"
      xml_content  = file("./api/bpd_io_citizen/original/findRankingUsingGET_policy.xml")
    },
    {
      operation_id = "updatePaymentMethodUsingPATCH"
      xml_content  = file("./api/bpd_io_citizen/original/updatePaymentMethodUsingPATCH_policy.xml")
    },
  ]
}

### v2 ###
module "bpd_io_citizen_v2" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = format("%s-bpd-io-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_citizen/v2/openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/bpd_io_citizen/v2/deleteUsingDELETE_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollment"
      xml_content = templatefile("./api/bpd_io_citizen/v2/enrollment_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/bpd_io_citizen/v2/findUsingGET_policy.xml")
    },
    {
      operation_id = "findRankingUsingGET"
      xml_content  = file("./api/bpd_io_citizen/v2/findRankingUsingGET_policy.xml")
    },
    {
      operation_id = "findRankingMilestoneUsingGET"
      xml_content  = file("./api/bpd_io_citizen/v2/findRankingMilestoneUsingGET_policy.xml")
    },
    {
      operation_id = "updatePaymentMethodUsingPATCH"
      xml_content  = file("./api/bpd_io_citizen/v2/updatePaymentMethodUsingPATCH_policy.xml")
    },
  ]
}

## 07 BPD IO Winning Transactions API ##
resource "azurerm_api_management_api_version_set" "bpd_io_winning_transactions" {
  name                = format("%s-bpd-io-winning-transactions", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Winning Transactions API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_winning_transactions_original" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = format("%s-bpd-io-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_winning_transactions.id

  description  = "Api and Models"
  display_name = "BPD IO Winning Transactions API"
  path         = "bpd/io/winning-transactions"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_winning_transactions/original/swagger.xml", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/bpd_io_winning_transactions/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getTotalScoreUsingGET"
      xml_content = templatefile("./api/bpd_io_winning_transactions/original/getTotalScoreUsingGET_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

### v2 ###
module "bpd_io_winning_transactions_v2" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.2.1"
  name                = format("%s-bpd-io-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_winning_transactions.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD IO Winning Transactions API"
  path         = "bpd/io/winning-transactions"
  protocols    = ["https", "http"]

  service_url = format("http://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_winning_transactions/v2/openapi.json", {
    host = local.apim_hostname #azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  xml_content = file("./api/bpd_io_winning_transactions/base_policy.xml")

  product_ids           = [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "findwinningtransactionsusingget"
      xml_content  = file("./api/bpd_io_winning_transactions/v2/findwinningtransactionsusingget_policy.xml")
    },
    {
      operation_id = "getTotalScoreUsingGET"
      xml_content = templatefile("./api/bpd_io_winning_transactions/v2/getTotalScoreUsingGET_policy.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}



##############
## Products ##
##############

module "app_io_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.2.1"

  product_id   = "app-io-product"
  display_name = "APP_IO_PRODUCT"
  description  = "APP_IO_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = templatefile("./api_product/app_io/policy.xml", {
    env_short         = var.env_short
    reverse_proxy_ip  = var.reverse_proxy_ip
    appio_timeout_sec = var.appio_timeout_sec
  })
}

module "bpd_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.2.1"

  product_id   = "bpd-api-product"
  display_name = "BPD_API_PRODUCT"
  description  = "BPD_API_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = file("./api_product/bpd_api/policy.xml")
}

module "issuer_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.2.1"

  product_id   = "issuer-api-product"
  display_name = "Issuer_API_Product"
  description  = "Issuer_API_Product"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/issuer_api/policy.xml")
}

module "fa_proxy_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.2.1"

  product_id   = "fa-proxy-product"
  display_name = "FA_PROXY_PRODUCT"
  description  = "FA_PROXY_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = false
  approval_required     = false

  policy_xml = templatefile("./api_product/fa_proxy/base_policy.xml", {
    bypass_cors = true
  })
}
