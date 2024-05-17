## BPD Info Privacy ##
module "api_bdp_info_privacy" {

  count = var.enable.bpd.api ? 1 : 0

  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"
  name                = format("%s-bpd-info-privacy", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD Info Privacy"
  path         = "cstar-bpd"
  protocols    = ["https"]

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

moved {
  from = module.api_bdp_info_privacy
  to   = module.api_bdp_info_privacy[0]
}

module "api_bpd-io_payment_instrument" {

  count = var.enable.bpd.api ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"

  name                = format("%s-bpd-io-payment-instrument-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD IO Payment Instrument API"
  path         = "bpd/io/payment-instruments"
  protocols    = ["https"]

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

moved {
  from = module.api_bpd-io_payment_instrument
  to   = module.api_bpd-io_payment_instrument[0]
}

module "api_bpd_pm_payment_instrument" {

  count = var.enable.bpd.api_pm ? 1 : 0

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"

  name                = format("%s-bpd-pm-payment-instrument", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD PM Payment Instrument"
  path         = "bpd/pm/payment-instrument"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_pm_payment_instrument/openapi.json", {
    host = local.apim_hostname # azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
  })

  # mock delete api only for dev and uat
  api_operation_policies = [
    {
      operation_id = "delete"
      xml_content  = file("./api/bpd_pm_payment_instrument/mock_delete_policy.xml")
    }
  ]

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.pm_api_product.product_id]
  subscription_required = true
}


moved {
  from = module.api_bpd_pm_payment_instrument
  to   = module.api_bpd_pm_payment_instrument[0]
}

module "api_bpd_tc" {

  count = var.enable.bpd.api ? 1 : 0


  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"

  name                = format("%s-bpd-tc-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD TC API"
  path         = "bpd/tc"
  protocols    = ["https"]

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

moved {
  from = module.api_bpd_tc
  to   = module.api_bpd_tc[0]
}

## 04 BPD IO Award Period API ##
resource "azurerm_api_management_api_version_set" "bpd_io_award_period" {
  count = var.enable.bpd.api ? 1 : 0

  name                = format("%s-bpd-io-award-period", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Award Period API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_award_period_original" {

  count = var.enable.bpd.api ? 1 : 0

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"
  name                 = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name  = module.apim.name
  resource_group_name  = azurerm_resource_group.rg_api.name
  version_set_id       = azurerm_api_management_api_version_set.bpd_io_award_period[count.index].id
  revision             = 2
  revision_description = "closing cashback"

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https"]

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

moved {
  from = module.bpd_io_award_period_original
  to   = module.bpd_io_award_period_original[0]
}

### v2 ###
module "bpd_io_award_period_v2" {

  count = var.enable.bpd.api ? 1 : 0

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"
  name                 = format("%s-bpd-io-award-period-api", var.env_short)
  api_management_name  = module.apim.name
  resource_group_name  = azurerm_resource_group.rg_api.name
  version_set_id       = azurerm_api_management_api_version_set.bpd_io_award_period[count.index].id
  revision             = 2
  revision_description = "closing cashback"
  api_version          = "v2"

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https"]

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

moved {
  from = module.bpd_io_award_period_v2
  to   = module.bpd_io_award_period_v2[0]
}

## 05 BPD IO Citizen API ##
resource "azurerm_api_management_api_version_set" "bpd_io_citizen" {

  count = var.enable.bpd.api ? 1 : 0

  name                = format("%s-bpd-io-citizen", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Citizen API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_citizen_original" {

  count = var.enable.bpd.api ? 1 : 0

  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"
  name                = format("%s-bpd-io-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen[count.index].id

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https"]

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

moved {
  from = module.bpd_io_citizen_original
  to   = module.bpd_io_citizen_original[0]
}

### v2 ###
module "bpd_io_citizen_v2" {

  count = var.enable.bpd.api ? 1 : 0

  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"
  name                = format("%s-bpd-io-citizen-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen[count.index].id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https"]

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

moved {
  from = module.bpd_io_citizen_v2
  to   = module.bpd_io_citizen_v2[0]
}

## 07 BPD IO Winning Transactions API ##
resource "azurerm_api_management_api_version_set" "bpd_io_winning_transactions" {

  count = var.enable.bpd.api ? 1 : 0

  name                = format("%s-bpd-io-winning-transactions", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Winning Transactions API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_winning_transactions_original" {

  count = var.enable.bpd.api ? 1 : 0

  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"
  name                = format("%s-bpd-io-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_winning_transactions[count.index].id

  description  = "Api and Models"
  display_name = "BPD IO Winning Transactions API"
  path         = "bpd/io/winning-transactions"
  protocols    = ["https"]

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

moved {
  from = module.bpd_io_winning_transactions_original
  to   = module.bpd_io_winning_transactions_original[0]
}

### v2 ###
module "bpd_io_winning_transactions_v2" {

  count = var.enable.bpd.api ? 1 : 0

  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v8.13.0"
  name                = format("%s-bpd-io-winning-transactions-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_winning_transactions[count.index].id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD IO Winning Transactions API"
  path         = "bpd/io/winning-transactions"
  protocols    = ["https"]

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

moved {
  from = module.bpd_io_winning_transactions_v2
  to   = module.bpd_io_winning_transactions_v2[0]
}

##############
## Products ##
##############
module "bpd_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v8.13.0"

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
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v8.13.0"

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
