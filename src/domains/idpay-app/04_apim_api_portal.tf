#
# IDPAY PRODUCTS
#

module "idpay_api_portal_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "idpay_api_portal_product"
  display_name = "IDPAY_APP_PORTAL_PRODUCT"
  description  = "IDPAY_APP_PORTAL_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./api_product/portal_api/policy_portal.xml.tpl", {
    jwt_cert_signing_kv_id = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.name,
    origins                = local.origins.base
  })

}

#
# IDPAY API
#

## IDPAY Welfare Portal User Permission API ##
module "idpay_permission_portal" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-portal-permission"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Welfare Portal User Permission"
  display_name = "IDPAY Welfare Portal User Permission API"
  path         = "idpay/authorization"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayportalwelfarebackendrolepermission/idpay/welfare"

  content_format = "openapi"
  content_value  = file("./api/idpay_role_permission/openapi.role-permission.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "userPermission"
      xml_content = templatefile("./api/idpay_role_permission/get-permission-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "savePortalConsent"
      xml_content = templatefile("./api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getPortalConsent"
      xml_content = templatefile("./api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Welfare Portal Initiative API ##
module "idpay_initiative_portal" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-initiative"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Welfare Portal Initiative"
  display_name = "IDPAY Welfare Portal Initiative API"
  path         = "idpay/initiative"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayportalwelfarebackeninitiative/idpay/initiative"

  content_format = "openapi"
  content_value  = file("./api/idpay_initiative/openapi.initiative.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getListOfOrganization"

      xml_content = templatefile("./api/idpay_initiative/get-organization-list.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitativeSummary"

      xml_content = templatefile("./api/idpay_initiative/get-initiative-summary.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeDetail"

      xml_content = templatefile("./api/idpay_initiative/get-initiative-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "saveInitiativeServiceInfo"

      xml_content = templatefile("./api/idpay_initiative/post-initiative-info.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeServiceInfo"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-info.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeGeneralInfo"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-general.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeGeneralInfoDraft"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-general-draft.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeBeneficiary"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-beneficiary.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeBeneficiaryDraft"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-beneficiary-draft.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateTrxAndRewardRules"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-reward.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateTrxAndRewardRulesDraft"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-reward-draft.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeRefundRule"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-refund.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeRefundRuleDraft"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-refund-draft.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeApprovedStatus"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-approve.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativeToCheckStatus"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-reject.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "updateInitiativePublishedStatus"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-publish.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "logicallyDeleteInitiative"

      xml_content = templatefile("./api/idpay_initiative/delete-initiative-general.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "suspendUser"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-suspension.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "readmitUser"

      xml_content = templatefile("./api/idpay_initiative/put-initiative-readmission.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    //CONFIG
    {
      operation_id = "getBeneficiaryConfigRules"

      xml_content = templatefile("./api/idpay_initiative/simple-mock-policy.xml", {})
    },
    {
      operation_id = "getTransactionConfigRules"

      xml_content = templatefile("./api/idpay_initiative/get-config-transaction-rule.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getMccConfig"

      xml_content = templatefile("./api/idpay_initiative/get-config-mcc.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "initiativeStatistics"

      xml_content = templatefile("./api/idpay_initiative/get-initiative-statistics.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRewardNotificationExportsPaged"

      xml_content = templatefile("./api/idpay_initiative/get-initiative-reward-notifications-exp.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRewardNotificationImportsPaged"

      xml_content = templatefile("./api/idpay_initiative/get-initiative-reward-notifications-imp.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getOnboardingStatus"

      xml_content = templatefile("./api/idpay_initiative/get-onboarding-status.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInitiativeOnboardingRankingStatusPaged"

      xml_content = templatefile("./api/idpay_initiative/get-ranking.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRankingFileDownload"

      xml_content = templatefile("./api/idpay_initiative/get-ranking-download.xml.tpl", {
        initiative-storage-account-name = module.idpay_initiative_storage.name
      })
    },
    {
      operation_id = "notifyCitizenRankings"

      xml_content = templatefile("./api/idpay_initiative/put-ranking-notify.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRewardFileDownload"

      xml_content = templatefile("./api/idpay_initiative/get-reward-download.xml.tpl", {
        refund-storage-account-name = module.idpay_refund_storage.name
      })
    },
    {
      operation_id = "putDispFileUpload"

      xml_content = templatefile("./api/idpay_initiative/put-disp-upload.xml.tpl", {
        refund-storage-account-name = module.idpay_refund_storage.name
      })
    },
    {
      operation_id = "uploadAndUpdateLogo"

      xml_content = templatefile("./api/idpay_initiative/put-logo-upload.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getDispFileErrors"

      xml_content = templatefile("./api/idpay_initiative/get-disp-errors.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    //BENEFICIARY DETAIL
    {
      operation_id = "getIban"

      xml_content = templatefile("./api/idpay_initiative/get-beneficiary-iban.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getTimeline"

      xml_content = templatefile("./api/idpay_initiative/get-beneficiary-timeline.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getTimelineDetail"

      xml_content = templatefile("./api/idpay_initiative/get-beneficiary-timeline-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getWalletDetail"

      xml_content = templatefile("./api/idpay_initiative/get-beneficiary-wallet.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getBeneficiaryOnboardingStatus"

      xml_content = templatefile("./api/idpay_initiative/get-beneficiary-onboarding-status.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getFamilyComposition"

      xml_content = templatefile("./api/idpay_initiative/get-beneficiary-onboarding-family-status.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    {
      operation_id = "getInstrumentList"

      xml_content = templatefile("./api/idpay_initiative/get-beneficiary-instruments.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
      })
    },
    //REFUND DETAIL
    {
      operation_id = "getExportSummary"

      xml_content = templatefile("./api/idpay_initiative/get-refund-export-summary.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getExportRefundsListPaged"

      xml_content = templatefile("./api/idpay_initiative/get-refund-list.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getRefundDetail"

      xml_content = templatefile("./api/idpay_initiative/get-refund-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
        pdv_retry_count                = var.pdv_retry_count
        pdv_retry_interval             = var.pdv_retry_interval
        pdv_retry_max_interval         = var.pdv_retry_max_interval
        pdv_retry_delta                = var.pdv_retry_delta
      })
    },
    //PORTAL TOKEN
    {
      operation_id = "getPagoPaAdminToken"

      xml_content = templatefile("./api/idpay_initiative/idpay_portal_token/jwt_idpay_portal_token.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname,
        jwt_cert_signing_thumbprint    = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.thumbprint
      })
    }
  ]

}

/*
##API used for generate IdPay Product Token test
resource "azurerm_api_management_api_operation" "idpay_portal_token" {
  operation_id        = "idpay_portal_token"
  api_name            = module.idpay_initiative_portal.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token"
  method              = "POST"
  url_template        = "/token"
  description         = "Endpoint which create IdPay token"
}
resource "azurerm_api_management_api_operation_policy" "idpay_portal_token_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_portal_token.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_portal_token.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_portal_token.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_portal_token.operation_id

  xml_content = templatefile("./api/idpay_initiative/idpay_portal_token/jwt_idpay_portal_token.xml.tpl", {
    ingress_load_balancer_hostname = var.ingress_load_balancer_hostname,
    jwt_cert_signing_thumbprint    = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.thumbprint
  })
}
*/

## IDPAY Welfare Portal Group API ##
module "idpay_group_portal" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-group"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Welfare Portal File Group"
  display_name = "IDPAY Welfare Portal File Group API"
  path         = "idpay/group"
  protocols    = ["https"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaygroup/"

  content_format = "openapi"
  content_value  = file("./api/idpay_group/openapi.group.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getGroupOfBeneficiaryStatusAndDetails"

      xml_content = templatefile("./api/idpay_group/get-group-status.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "uploadGroupOfBeneficiary"

      xml_content = templatefile("./api/idpay_group/put-group-upload.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Merchant API ##
module "idpay_merchant_portal" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-merchant"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Merchant"
  display_name = "IDPAY Merchant API"
  path         = "idpay/merchant"
  protocols    = ["https"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaymerchant/"

  content_format = "openapi"
  content_value  = file("./api/idpay_merchant/openapi.merchant.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getMerchantList"

      xml_content = templatefile("./api/idpay_merchant/get-merchant-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getMerchantDetail"

      xml_content = templatefile("./api/idpay_merchant/get-merchant-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "uploadMerchantList"

      xml_content = templatefile("./api/idpay_merchant/put-merchant-upload.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Welfare Portal Email API ##
module "idpay_notification_email_api" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-idpay-email"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Notification Email"
  display_name = "IDPAY Notification Email API"
  path         = "idpay/email-notification"
  protocols    = ["https"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpaynotificationemail/"

  content_format = "openapi"
  content_value  = file("./api/idpay_notification_email/openapi.notification.email.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.idpay_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "sendEmail"

      xml_content = templatefile("./api/idpay_notification_email/post-notify-email-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "getInstitutionProductUserInfo"

      xml_content = templatefile("./api/idpay_notification_email/get-institution-user-info-policy.xml.tpl", {
        ingress_load_balancer_hostname  = var.ingress_load_balancer_hostname,
        selc_base_url                   = var.selc_base_url,
        selc_timeout_sec                = var.selc_timeout_sec
        selc_external_api_key_reference = azurerm_api_management_named_value.selc_external_api_key.display_name
      })
    }
  ]

  depends_on = [
    azurerm_api_management_named_value.selc_external_api_key
  ]

}

#
# Named values
#

# selfcare api
resource "azurerm_api_management_named_value" "selc_external_api_key" {

  name                = format("%s-selc-external-api-key-secret", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "selc-external-api-key"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.selc_external_api_key_secret.versionless_id
  }

}

data "azurerm_key_vault_secret" "selc_external_api_key_secret" {
  name         = "selc-external-api-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

# storage access key


# storage

#tfsec:ignore:AZU023

resource "azurerm_api_management_named_value" "refund_storage_access_key" {

  name                = format("%s-refund-storage-access-key", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "refund-storage-access-key"
  secret       = true
  value_from_key_vault {
    secret_id = azurerm_key_vault_secret.refund_storage_access_key.id
  }

}

resource "azurerm_api_management_named_value" "initiative_storage_access_key" {

  name                = format("%s-initiative-storage-access-key", var.env_short)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "initiative-storage-access-key"
  secret       = true
  value_from_key_vault {
    secret_id = azurerm_key_vault_secret.initiative_storage_access_key.id
  }

}
