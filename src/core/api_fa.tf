
## 08 FA IO Customer API ##
resource "azurerm_api_management_api_version_set" "fa_io_customers" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-customer", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Customer API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_customers_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-customer-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_customers[0].id

  description  = "Api and Models"
  display_name = "FA IO Customer API"
  path         = "fa/io/customer"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famscustomer/fa/customer", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_io_customer/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  # bypass global cors policy on UAT environment
  xml_content = var.env_short != "d" ? file("./api/fa_io_customer/bypass_cors_policy.xml") : file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/fa_io_customer/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentUsingPUT"
      xml_content = templatefile("./api/fa_io_customer/enrollmentUsingPUT_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/fa_io_customer/findUsingGET_policy.xml.tpl")
    },
  ]
}

## 09 FA HB Customer API
resource "azurerm_api_management_api_version_set" "fa_hb_customers" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-hb-customer", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA HB Customer API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_hb_customers_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-hb-customer-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_hb_customers[0].id

  description  = "Api and Models"
  display_name = "FA HB Customer API"
  path         = "fa/hb/customer"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famscustomer/fa/customer", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_hb_customer/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "deleteUsingDELETE"
      xml_content = templatefile("./api/fa_hb_customer/deleteUsingDELETE_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "enrollmentUsingPUT"
      xml_content = templatefile("./api/fa_hb_customer/enrollmentUsingPUT_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "findUsingGET"
      xml_content  = file("./api/fa_hb_customer/findUsingGET_policy.xml.tpl")
    },
  ]
}

## 10 FA IO Payment Instruments API ##
resource "azurerm_api_management_api_version_set" "fa_io_payment_instruments" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-payment-instruments", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Payment Instruments API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_payment_instruments_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-payment-instruments-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_payment_instruments[0].id

  description  = ""
  display_name = "FA IO Payment Instruments API"
  path         = "fa/io/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famspaymentinstrument/fa/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_io_payment_instruments/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = var.env_short != "d" ? file("./api/fa_io_payment_instruments/bypass_cors_policy.xml") : file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # PUT enrollPaymentInstrumentIO
      operation_id = "enrollmentUsingPUT",
      xml_content = templatefile("./api/fa_io_payment_instruments/enrollmentUsingPUT_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
        reverse-proxy-ip                     = var.reverse_proxy_ip
      })
    },
    {
      # DEL deletePaymentInstrumentIO
      operation_id = "deleteUsingDELETE",
      xml_content = templatefile("./api/fa_io_payment_instruments/deleteUsingDELETE_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET statusPaymentInstrumentIO
      operation_id = "findUsingGET",
      xml_content = templatefile("./api/fa_io_payment_instruments/findUsingGET_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
  ]
}

## 11 FA HB Payment Instruments API ##
resource "azurerm_api_management_api_version_set" "fa_hb_payment_instruments" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-hb-payment-instruments", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA HB Payment Instruments API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_hb_payment_instruments_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-hb-payment-instruments-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_hb_payment_instruments[0].id

  description  = ""
  display_name = "FA HB Payment Instruments API"
  path         = "fa/hb/payment-instruments"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famspaymentinstrument/fa/payment-instruments", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_hb_payment_instruments/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      # DEL BPay deletePaymentInstrumentHB
      operation_id = "deleteUsingDELETEBpay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/deleteUsingDELETE_BPAY_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
      })
    },
    {
      # GET BPay statusPaymentInstrumentHB
      operation_id = "findUsingGETBpay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/findUsingGET_BPAY_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
      })
    },
    {
      # PUT enrollPaymentInstrumentHB
      operation_id = "enrollmentUsingPUTCard",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_Card_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
        reverse-proxy-ip             = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB BPay
      operation_id = "enrollmentUsingPUTBpay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_BPAY_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
        reverse-proxy-ip             = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB Other
      operation_id = "enrollmentUsingPUTOther",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_Other_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
        reverse-proxy-ip             = var.reverse_proxy_ip
      })
    },
    {
      # PUT enrollPaymentInstrumentHB Satispay
      operation_id = "enrollmentUsingPUTSatispay",
      xml_content = templatefile("./api/fa_hb_payment_instruments/enrollmentUsingPUT_Satispay_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
        reverse-proxy-ip             = var.reverse_proxy_ip
      })
    },
    {
      # DEL deletePaymentInstrumentHB
      operation_id = "deleteUsingDELETE",
      xml_content = templatefile("./api/fa_hb_payment_instruments/deleteUsingDELETE_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
      })
    },
    {
      # PATCH patchPaymentInstrument
      operation_id = "patchUsingPATCH",
      xml_content = templatefile("./api/fa_hb_payment_instruments/patchUsingPATCH_policy.xml.tpl", {
        pm-backend-url                       = var.pm_backend_url,
        pm-timeout-sec                       = var.pm_timeout_sec
        bpd-pm-client-certificate-thumbprint = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
        env_short                            = var.env_short
      })
    },
    {
      # GET statusPaymentInstrumentHB
      operation_id = "findUsingGET",
      xml_content = templatefile("./api/fa_hb_payment_instruments/findUsingGET_policy.xml.tpl", {
        pm-backend-url               = var.pm_backend_url,
        pm-timeout-sec               = var.pm_timeout_sec
        pagopa-platform-api-key-name = azurerm_api_management_named_value.pagopa_platform_api_key[count.index].display_name
        env_short                    = var.env_short
      })
    },
  ]
}

## 12 FA REGISTER Transaction API
resource "azurerm_api_management_api_version_set" "fa_register_transactions" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-register-transaction", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA REGISTER Transaction API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_register_transactions_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-register-transaction-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_register_transactions[0].id

  description  = "Api and Models"
  display_name = "FA REGISTER Transaction API"
  path         = "fa/transaction"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famstransaction/fa/transaction", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_register_transaction/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "createPosTransactionUsingPOST"
      xml_content = templatefile("./api/fa_register_transaction/createPosTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "getPosTransactionUsingGET"
      xml_content = templatefile("./api/fa_register_transaction/getPosTransactionUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "getPosTransactionCustomerUsingGET"
      xml_content = templatefile("./api/fa_register_transaction/getPosTransactionCustomerUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "outcomePosTransactionUsingPOST"
      xml_content = templatefile("./api/fa_register_transaction/outcomePosTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

## 12 FA IO Transaction API
resource "azurerm_api_management_api_version_set" "fa_io_transactions" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-transaction", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Transaction API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_transactions_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-transaction-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_transactions[0].id

  description  = "Api and Models"
  display_name = "FA IO Transaction API"
  path         = "fa/io/transaction"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famstransaction/fa/transaction", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_io_transaction/openapi.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = var.env_short != "d" ? file("./api/fa_io_transaction/bypass_cors_policy.xml") : file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getTransactionListUsingGET"
      xml_content = templatefile("./api/fa_io_transaction/getTransactionListUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
  ]
}

## 13 FA Mock API
resource "azurerm_api_management_api_version_set" "fa_mock" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-mock", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA Mock API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_mock_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-mock-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_mock[0].id

  description  = "Api and Models"
  display_name = "FA Mock API"
  path         = "fa/mock"
  protocols    = ["https", "http"]

  service_url = format("http://%s/cstariobackendtest/fa/mock/poc", var.reverse_proxy_ip)

  content_value = templatefile("./api/fa_mock/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.fa_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "sendRegisterTransactionUsingPOST"
      xml_content = templatefile("./api/fa_mock/sendRegisterTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "sendAcquirerTransactionUsingPOST"
      xml_content = templatefile("./api/fa_mock/sendAcquirerTransactionUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "searchAcquirerTransactionErrorUsingPOST"
      xml_content = templatefile("./api/fa_mock/searchAcquirerTransactionErrorUsingPOST_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}

## 14 FA IO Merchant API
resource "azurerm_api_management_api_version_set" "fa_io_merchant" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-io-merchant", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA IO Merchant API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_io_merchant_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-io-merchant-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_io_merchant[0].id

  description  = "Api and Models"
  display_name = "FA IO Merchant API"
  path         = "fa/io/merchant"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famsmerchant/fa/merchant", var.reverse_proxy_ip)

  content_format = "openapi"
  content_value = templatefile("./api/fa_io_merchant/swagger.yaml", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.app_io_product.product_id, module.fa_api_product.product_id] : [module.app_io_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "onboardingMerchantByIOUsingPut"
      xml_content = templatefile("./api/fa_io_merchant/onboardingMerchantByIOUsingPut_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "getMerchantByShopId"
      xml_content = templatefile("./api/fa_io_merchant/getMerchantDetails.xml", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}

## 14 FA EXT Merchant API
resource "azurerm_api_management_api_version_set" "fa_ext_merchant" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-ext-merchant", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA EXT Merchant API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_ext_merchant_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-ext-merchant-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_ext_merchant[0].id

  description  = "Api and Models"
  display_name = "FA EXT Merchant API"
  path         = "fa/ext/merchant"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famsmerchant/fa/merchant", var.reverse_proxy_ip)

  content_value = templatefile("./api/fa_ext_merchant/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "onboardingMerchantByProviderUsingPut"
      xml_content = templatefile("./api/fa_ext_merchant/onboardingMerchantByProviderUsingPut_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "onboardingMerchantByOtherUsingPut"
      xml_content = templatefile("./api/fa_ext_merchant/onboardingMerchantByOtherUsingPut_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "activeContractByShopIdUsingGet"
      xml_content = templatefile("./api/fa_ext_merchant/activeContractByShopIdUsingGet_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    },
    {
      operation_id = "contractListByShopIdUsingGet"
      xml_content = templatefile("./api/fa_ext_merchant/contractListByShopIdUsingGet_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}

## 14 FA EXT Provider API
resource "azurerm_api_management_api_version_set" "fa_ext_provider" {
  count               = var.enable_api_fa ? 1 : 0
  name                = format("%s-fa-ext-provider", var.env_short)
  resource_group_name = azurerm_resource_group.rg_api.name
  api_management_name = module.apim.name
  display_name        = "FA EXT Provider API"
  versioning_scheme   = "Segment"
}

#Original#
module "fa_ext_provider_original" {
  count               = var.enable_api_fa ? 1 : 0
  source              = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16"
  name                = format("%s-fa-ext-provider-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name
  version_set_id      = azurerm_api_management_api_version_set.fa_ext_provider[0].id

  description  = "Api and Models"
  display_name = "FA EXT Provider API"
  path         = "fa/ext/provider"
  protocols    = ["https", "http"]

  service_url = format("http://%s/famsinvoiceprovider/fa/provider", var.reverse_proxy_ip)

  content_value = templatefile("./api/fa_ext_provider/swagger.json.tpl", {
    host = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = var.env_short == "d" ? [module.issuer_api_product.product_id, module.fa_api_product.product_id] : [module.issuer_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "providerListUsingGET"
      xml_content = templatefile("./api/fa_ext_provider/providerListUsingGET_policy.xml.tpl", {
        reverse-proxy-ip = var.reverse_proxy_ip
      })
    }
  ]
}


module "fa_api_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16"

  product_id   = "fa-api-product"
  display_name = "FA_API_PRODUCT"
  description  = "FA_API_PRODUCT"

  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name

  published             = true
  subscription_required = true
  approval_required     = false

  policy_xml = templatefile("./api_product/fa_api/policy.xml", {
    env_short = var.env_short
  })
}


module "fa_api_proxy" {
  count  = var.env_short == "d" ? 0 : 1
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.16.0"

  name                = format("%s-proxy-api", var.env_short)
  api_management_name = module.apim.name
  resource_group_name = azurerm_resource_group.rg_api.name


  description  = "FA Proxing API"
  display_name = "FA Proxing API"
  path         = "fa/proxy"
  protocols    = ["https"]

  service_url = ""

  # Mandatory field when api definition format is openapi
  content_format = "openapi"
  content_value = templatefile("./api/fa_proxy/openapi.yml", {
    host = "https://httpbin.org"
  })

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.fa_proxy_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getIoSession"
      xml_content = templatefile("./api/fa_proxy/get_session_policy.xml", {
        io-backend = var.env_short == "p" ? "https://app-backend.io.italia.it/api/v1" : "http://${var.reverse_proxy_ip}/cstariobackendtest"
      })
    },
    {
      operation_id = "getWallet",
      xml_content = templatefile("./api/fa_proxy/get_wallet_policy.xml", {
        apim-pago-platform = var.pagopa_platform_url
      })
    }
  ]
}
