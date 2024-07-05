#
# EMD PRODUCTS
#

module "emd_api_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

  product_id   = "emd_api_product"
  display_name = "EMD_PRODUCT"
  description  = "EMD_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/emd/policy_emd.xml", {
    rate_limit_emd = var.rate_limit_emd_product
    }
  )

  groups = ["developers"]
}

## EMD MESSAGE CORE ##
module "emd_message_core" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api?ref=v6.15.2"

  name                = "${var.env_short}-emd-message-core"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "EMD MESSAGE CORE"
  display_name = "EMD MESSAGE CORE API"
  path         = "emd/message-core"
  protocols    = ["https"]

  service_url = "${local.ingress_load_balancer_https}/emdmessagecore/emd/message-core"

  content_format = "openapi"
  content_value  = file("./api/emd_message_core/openapi.emd.yml")

  xml_content = file("./api/base_policy.xml")

  product_ids           = [module.emd_api_product.product_id]
  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "submitMessage"

      xml_content = templatefile("./api/emd_message_core/post-send-courtesy-message-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  ]
}
