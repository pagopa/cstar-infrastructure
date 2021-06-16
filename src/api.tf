resource "azurerm_resource_group" "rg_api" {
  name     = format("%s-api-rg", local.project)
  location = var.location

  tags = var.tags
}

locals {
  apim_cert_name_proxy_endpoint = format("%s-proxy-endpoint-cert", local.project)
}

###########################
## Api Management (apim) ## 
###########################

module "apim" {
  source               = "git::https://github.com/pagopa/azurerm.git//api_management?ref=v1.0.7"
  subnet_id            = module.apim_snet.id
  location             = azurerm_resource_group.rg_api.location
  name                 = format("%s-apim", local.project)
  resource_group_name  = azurerm_resource_group.rg_api.name
  publisher_name       = var.apim_publisher_name
  publisher_email      = var.apim_publisher_email
  sku_name             = var.apim_sku
  virtual_network_type = "Internal"

  # policy_path = "./api/base_policy.xml"

  tags = var.tags
}

resource "azurerm_api_management_custom_domain" "api_custom_domain" {
  api_management_id = module.apim.id

  proxy {
    host_name    = trim(azurerm_private_dns_a_record.private_dns_a_record_api.fqdn, ".")
    key_vault_id = azurerm_key_vault_certificate.apim_proxy_endpoint_cert.secret_id
  }

  # developer_portal {
  #   host_name    = "portal.example.com"
  #   key_vault_id = azurerm_key_vault_certificate.test.secret_id
  # }
}

module "api_bdp_hb_award_period" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-hb-award-period-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD HB Award Period API"
  path         = "bpd/hb/award-periods"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_hb_award_period/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "findAll",
      xml_content  = file("./api/bpd_hb_award_period/get_findall_policy.xml")
    },
    {
      operation_id = "testcache"
      xml_content  = file("./api/bpd_hb_award_period/test_cache_policy.xml")
    }
  ]
}

module "api_bdp_info_privacy" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"
  name                = "bpd-info-privacy"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD Info Privacy"
  path         = "cstar-bpd"
  protocols    = ["https"]

  service_url = format("https://%s/%s", module.cstarblobstorage.primary_blob_host, azurerm_storage_container.info_privacy.name)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_info_privacy/openapi.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "cstarinfoprivacy"
      xml_content  = file("./api/bpd_info_privacy/cstarinfoprivacy_policy.xml")
    }
  ]
}

module "api_bpd-io_payment_instrument" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-io-payment-instrument-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD IO Payment Instrument API"
  path         = "bpd/io/payment-instruments"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_payment_instrument/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/bpd_io_payment_instrument/policy.xml")

  api_operation_policies = [
    {
      operation_id = "enrollmentPaymentInstrumentIOUsingPUT",
      xml_content = templatefile("./api/bpd_io_payment_instrument/put_enrollment_payment_instrument_io_policy.xml.tpl", {
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
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-pm-payment-instrument"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = ""
  display_name = "BPD PM Payment Instrument"
  path         = "bpd/pm/payment-instrument"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_pm_payment_instrument/openapi.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")
}

module "api_bpd_io_backend_test" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-io-backend-test-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "TEST IO Backend API server."
  display_name = "BPD IO Backend TEST API"
  path         = "bpd/pagopa/api/v1"
  protocols    = ["https"]

  service_url = format("https://%s/cstariobackendtest/bpd/pagopa/api/v1", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_backend_test/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "getToken",
      xml_content = templatefile("./api/bpd_io_backend_test/post_get_token_policy.xml.tpl", {
        reverse_proxy_ip = var.reverse_proxy_ip
      })
    },
  ]
}

module "api_bpd_tc" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-tc-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  description  = "Api and Models"
  display_name = "BPD TC API"
  path         = "bpd/tc"
  protocols    = ["https"]

  service_url = format("https://%s/%s", module.cstarblobstorage.primary_blob_host,
  azurerm_storage_container.bpd_terms_and_conditions.name)

  content_value = templatefile("./api/bpd_tc/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

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

## 01 BPD HB Citizen API
resource "azurerm_api_management_api_version_set" "bpd_hb_citizen" {
  name                = "bpd-hb-citizen"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD HB Citizen API"
  versioning_scheme   = "Segment"
}


### Original (swagger 2.0.x)
module "bpd_hb_citizen_original" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"
  name                = "bpd-hb-citizen-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_citizen.id

  description  = "Api and Models"
  display_name = "BPD HB Citizen API"
  path         = "bpd/hb/citizens"
  protocols    = ["https"]

  service_url = format("https://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_hb_citizen/original/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "delete",
      xml_content = templatefile("./api/bpd_hb_citizen/original/del_delete_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentCitizenHB",
      xml_content = templatefile("./api/bpd_hb_citizen/original/put_enrollment_citizen_hb.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "find",
      xml_content  = file("./api/bpd_hb_citizen/original/get_find_policy.xml")
    },
    {
      operation_id = "findranking",
      xml_content  = file("./api/bpd_hb_citizen/original/get_find_ranking.xml")
    },
    {
      operation_id = "updatePaymentMethod",
      xml_content  = file("./api/bpd_hb_citizen/original/patch_update_payment_method.xml")
    },
  ]
}

# V2 (openapi 3.0.x)
module "bpd_hb_citizen_original_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"
  name                = "bpd-hb-citizen-api"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_citizen.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD HB Citizen API"
  path         = "bpd/hb/citizens"
  protocols    = ["https"]

  service_url = format("https://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile(format("./api/bpd_hb_citizen/v2/openapi.json.tpl"), {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "delete",
      xml_content = templatefile("./api/bpd_hb_citizen/v2/del_delete_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentCitizenHB",
      xml_content = templatefile("./api/bpd_hb_citizen/v2/put_enrollment_citizen_hb.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "find",
      xml_content  = file("./api/bpd_hb_citizen/v2/get_find_policy.xml")
    },
    {
      operation_id = "findranking",
      xml_content  = file("./api/bpd_hb_citizen/v2/get_find_ranking.xml")
    },
    {
      operation_id = "updatePaymentMethod",
      xml_content  = file("./api/bpd_hb_citizen/v2/patch_update_payment_method.xml")
    },
  ]
}

## 02 BPD HB Payment Instruments API ##
resource "azurerm_api_management_api_version_set" "bpd_hb_payment_instruments" {
  name                = "bpd-hb-payment-instruments"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD HB Payment Instruments API"
  versioning_scheme   = "Segment"
}

### Original ###
module "bpd_hb_payment_instruments" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"
  name                = "bpd-hb-payment-instruments"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_payment_instruments.id

  description  = ""
  display_name = "BPD HB Payment Instruments API"
  path         = "bpd/hb/payment-instruments"
  protocols    = ["https"]

  service_url = format("https://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_payment_instruments/original/openapi.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      # Del BPay deletePaymentInstrumentHB
      operation_id = "5fdb377a52411ce8e7b9d5f6",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/5fdb377a52411ce8e7b9d5f6_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
    {
      # Get BPay statusPaymentInstrumentHB
      operation_id = "5fdb37ee7e211f8e0ac2dc45",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/5fdb37ee7e211f8e0ac2dc45_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
    {
      # Del deletePaymentInstrumentHB
      operation_id = "deletepaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/deletepaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
    {
      # put enrollPaymentInstrumentHB
      operation_id = "enrollPaymentInstrumentHB",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/enrollPaymentInstrumentHB_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # put enrollPaymentInstrumentHB BPay
      operation_id = "5f98984972e5123d4571984b",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/5f98984972e5123d4571984b_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # put enrollPaymentInstrumentHB BPay
      operation_id = "5faade7fc12a87300a91769a",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/5faade7fc12a87300a91769a_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # put enrollPaymentInstrumentHB Other
      operation_id = "6040bbd70a02ff56cad6aefd",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/6040bbd70a02ff56cad6aefd_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # put enrollPaymentInstrumentHB Satispay
      operation_id = "5fabb9644b1afaae5cc91a19",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/5fabb9644b1afaae5cc91a19_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # get statusPaymentInstrumentHB
      operation_id = "statuspaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/statuspaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
  ]
}

### V2 ###
module "bpd_hb_payment_instruments_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"
  name                = "bpd-hb-payment-instruments"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_payment_instruments.id
  api_version         = "v2"

  description  = ""
  display_name = "BPD HB Payment Instruments API"
  path         = "bpd/hb/payment-instruments"
  protocols    = ["https"]

  service_url = format("https://%s/bpdmspaymentinstrument/bpd/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_payment_instruments/v2/openapi.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      # BPay deletePaymentInstrumentHB
      operation_id = "5fdb377a52411ce8e7b9d5f6",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/statuspaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
    {
      # Get BPay statusPaymentInstrumentHB
      operation_id = "5fdb37ee7e211f8e0ac2dc45",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/5fdb37ee7e211f8e0ac2dc45_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
    {
      # Del deletePaymentInstrumentHB
      operation_id = "deletepaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/deletepaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
    {
      # get statusPaymentInstrumentHB
      operation_id = "statuspaymentinstrumenthb",
      xml_content = templatefile("./api/bpd_hb_payment_instruments/original/statuspaymentinstrumenthb_policy.xml.tpl", {
        pm-backend-host                      = var.pm_backend_host,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
      })
    },
  ]
}

## BPD HB Winning Transactions API ##
resource "azurerm_api_management_api_version_set" "bpd_hb_winning_transactions" {
  name                = "bpd-hb-winning-transactions"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD HB Winning Transactions API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_hb_winning_transactions" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"
  name                = "bpd-hb-winning-transactions"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_winning_transactions.id

  description  = "Api and Models"
  display_name = "BPD HB Winning Transactions API"
  path         = "bpd/hb/winning-transactions"
  protocols    = ["https"]

  service_url = format("https://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_hb_winning_transactions/original/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      # get getTotalCashback
      operation_id = "5f983f1e4d8a629c492473c1",
      xml_content = templatefile("./api/bpd_hb_winning_transactions/original/5f983f1e4d8a629c492473c1_policy.xml.tpl", {
        reverse-proxy-IP = var.reverse_proxy_ip
      })
    },
  ]
}

### v2 ###
module "bpd_hb_winning_transactions_v2" {
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"
  name                = "bpd-hb-winning-transactions"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_hb_winning_transactions.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD HB Winning Transactions API"
  path         = "bpd/hb/winning-transactions"
  protocols    = ["https"]

  service_url = format("https://%s/bpd/hb/winning-transactions/v2", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_hb_winning_transactions/v2/openapi.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      # get getTotalCashback
      operation_id = "5f983f1e4d8a629c492473c1",
      xml_content = templatefile("./api/bpd_hb_winning_transactions/v2/5f983f1e4d8a629c492473c1_policy.xml.tpl", {
        reverse-proxy-IP = var.reverse_proxy_ip
      })
    },
  ]
}

## BPD IO Award Period API ##
resource "azurerm_api_management_api_version_set" "bpd_io_award_period" {
  name                = "bpd-io-award-period"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Award Period API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_award_period" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-io-award-period"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_award_period.id

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_award_period/original/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "findAllUsingGET"
      xml_content  = file("./api/bpd_io_award_period/original/findAllUsingGET_policy.xml")
    }
  ]
}

### v2 ###
module "bpd_io_award_period_v2" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-io-award-period"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_award_period.id
  api_version         = "v2"

  description  = "findAll"
  display_name = "BPD IO Award Period API"
  path         = "bpd/io/award-periods"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmsawardperiod/bpd/award-periods", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_award_period/v2/openapi.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "findAllUsingGET"
      xml_content  = file("./api/bpd_io_award_period/v2/findAllUsingGET_policy.xml")
    }
  ]
}

## BPD IO Citizen API ##
resource "azurerm_api_management_api_version_set" "bpd_io_citizen" {
  name                = "bpd-io-citizen"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Citizen API"
  versioning_scheme   = "Segment"
}

### original ###
module "bpd_io_citizen" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-io-citizen"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen.id

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_value = templatefile("./api/bpd_io_citizen/original/swagger.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/bpd_io_citizen/original/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-IP = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollment"
      xml_content = templatefile("./api/bpd_io_citizen/original/enrollment_policy.xml.tpl", {
        reverse-proxy-IP = var.reverse_proxy_ip
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
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bpd-io-citizen"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bpd_io_citizen.id
  api_version         = "v2"

  description  = "Api and Models"
  display_name = "BPD IO Citizen API"
  path         = "bpd/io/citizen"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmscitizen/bpd/citizens", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/bpd_io_citizen/v2/openapi.json.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/bpd_io_citizen/v2/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-IP = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollment"
      xml_content = templatefile("./api/bpd_io_citizen/v2/enrollment_policy.xml.tpl", {
        reverse-proxy-IP = var.reverse_proxy_ip
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

## BPD IO Winning Transactions API ##
resource "azurerm_api_management_api_version_set" "bdp_io_winning_transactions" {
  name                = "bdp-io-winning-transactions"
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "BPD IO Winning Transactions API"
  versioning_scheme   = "Segment"
}

### original ###
module "bdp_io_winning_transactions" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.7"

  name                = "bdp-io-winning-transactions"
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.bdp_io_winning_transactions.id

  description  = "Api and Models"
  display_name = "BPD IO Winning Transactions API"
  path         = "bpd/io/winning-transactions"
  protocols    = ["https"]

  service_url = format("http://%s/bpdmswinningtransaction/bpd/winning-transactions", var.reverse_proxy_ip)

  content_value = templatefile("./api/bdp_io_winning_transactions/original/swagger.xml.tpl", {
    host = module.apim.gateway_hostname
  })

  xml_content = file("./api/base_policy.xml")

  api_operation_policies = []
}