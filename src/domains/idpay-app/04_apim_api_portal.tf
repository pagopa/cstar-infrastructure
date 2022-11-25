#
# IDPAY PRODUCTS
#

module "idpay_api_portal_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

  product_id   = "idpay_api_portal_product"
  display_name = "IDPAY_APP_PORTAL_PRODUCT"
  description  = "IDPAY_APP_PORTAL_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 50

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
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

  name                = "${var.env_short}-idpay-portal-permission"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY Welfare Portal User Permission"
  display_name = "IDPAY Welfare Portal User Permission API"
  path         = "idpay/authorization"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayportalwelfarebackendrolepermission/idpay/welfare"

  content_format = "openapi"
  content_value  = file("./api/idpay_role_permission/openapi.permission.yml")

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
      operation_id = "saveConsent"
      xml_content = templatefile("./api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    },
    {
      operation_id = "retrieveConsent"
      xml_content = templatefile("./api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]

}

## IDPAY Welfare Portal Initiative API ##
module "idpay_initiative_portal" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

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
    }
  ]

}


## IDPAY Welfare Portal Group API ##
module "idpay_group_portal" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

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

## IDPAY Welfare Portal Email API ##
module "idpay_notification_email_api" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v2.18.2"

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
    secret_id = data.azurerm_key_vault_secret.selc_external_api_key_secret.id
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
