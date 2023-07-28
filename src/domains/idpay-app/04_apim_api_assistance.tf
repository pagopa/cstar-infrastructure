#
# IDPAY PRODUCTS
#

module "idpay_api_assistance_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "idpay_api_assistance_product"
  display_name = "IDPAY_API_ASSISTANCE PRODUCT"
  description  = "IDPAY_API_ASSISTANCE PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = file("./api_product/assistance/policy_assistance.xml")

}

#
# IDPAY API
#

## IDPAY Assistance API ##

module "idpay_api_assistance" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-assistance"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Assistance"
  display_name = "IDPAY Assistance"
  path         = "idpay/assistance"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayportalwelfarebackeninitiative/idpay/initiative"

  content_format = "openapi"
  content_value  = file("./api/idpay_assistance/openapi.assistance.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_assistance_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "getListOfOrganization"

      xml_content = templatefile("./api/idpay_assistance/get-organization-list.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitativeSummary"

      xml_content = templatefile("./api/idpay_assistance/get-initiative-summary.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeDetail"

      xml_content = templatefile("./api/idpay_assistance/get-initiative-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "initiativeStatistics"

      xml_content = templatefile("./api/idpay_assistance/get-initiative-statistics.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRewardNotificationExportsPaged"

      xml_content = templatefile("./api/idpay_assistance/get-initiative-reward-notifications-exp.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRewardNotificationImportsPaged"

      xml_content = templatefile("./api/idpay_assistance/get-initiative-reward-notifications-imp.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getOnboardingStatus"

      xml_content = templatefile("./api/idpay_assistance/get-onboarding-status.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeOnboardingRankingStatusPaged"

      xml_content = templatefile("./api/idpay_assistance/get-ranking.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRankingFileDownload"

      xml_content = templatefile("./api/idpay_assistance/get-ranking-download.xml.tpl", {
        initiative-storage-account-name = local.initiative_storage_fqdn
      })
    },
    {
      operation_id = "getRewardFileDownload"

      xml_content = templatefile("./api/idpay_assistance/get-reward-download.xml.tpl", {
        refund-storage-account-name = module.idpay_refund_storage.name
      })
    },
    {
      operation_id = "getDispFileErrors"

      xml_content = templatefile("./api/idpay_assistance/get-disp-errors.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    //BENEFICIARY DETAIL
    {
      operation_id = "getIban"

      xml_content = templatefile("./api/idpay_assistance/get-beneficiary-iban.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getTimeline"

      xml_content = templatefile("./api/idpay_assistance/get-beneficiary-timeline.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getTimelineDetail"

      xml_content = templatefile("./api/idpay_assistance/get-beneficiary-timeline-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getWalletDetail"

      xml_content = templatefile("./api/idpay_assistance/get-beneficiary-wallet.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getBeneficiaryOnboardingStatus"

      xml_content = templatefile("./api/idpay_assistance/get-beneficiary-onboarding-status.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getInstrumentList"

      xml_content = templatefile("./api/idpay_assistance/get-beneficiary-instruments.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    //REFUND DETAIL
    {
      operation_id = "getExportSummary"

      xml_content = templatefile("./api/idpay_assistance/get-refund-export-summary.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getExportRefundsListPaged"

      xml_content = templatefile("./api/idpay_assistance/get-refund-list.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRefundDetail"

      xml_content = templatefile("./api/idpay_assistance/get-refund-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
        pdv_retry_count                = var.pdv_retry_count
        pdv_retry_interval             = var.pdv_retry_interval
        pdv_retry_max_interval         = var.pdv_retry_max_interval
        pdv_retry_delta                = var.pdv_retry_delta
      })
    },
    {
      operation_id = "getMerchantList"

      xml_content = templatefile("./api/idpay_assistance/get-merchant-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getMerchantDetail"

      xml_content = templatefile("./api/idpay_assistance/get-merchant-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getMerchantInitiativeStatistics"

      xml_content = templatefile("./api/idpay_assistance/get-merchant-statistics-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getMerchantTransactions"

      xml_content = templatefile("./api/idpay_assistance/get-merchant-transactions-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getMerchantTransactionsProcessed"

      xml_content = templatefile("./api/idpay_assistance/get-merchant-transactions-processed-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

