#
# IDPAY PRODUCTS
#
/*
module "idpay_api_io_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

  product_id   = "idpay_api_io_product"
  display_name = "IDPAY_APP_IO_PRODUCT"
  description  = "IDPAY_APP_IO_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50

  policy_xml = templatefile("./api_product/policy.xml.tpl", {
    env_short           = var.env_short
    reverse_proxy_be_io = var.reverse_proxy_be_io
    appio_timeout_sec   = var.appio_timeout_sec
  })

  groups = ["developers"]
}
*/
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
  path         = "idpay/welfare/authorization"
  protocols    = ["https", "http"]

  service_url = "http://${var.ingress_load_balancer_hostname}/idpayportalwelfarebackendrolepermission/idpay/welfare"
  
  content_format = "openapi"
  content_value = file("./api/idpay_role_permission/swagger.role.permission.yml")

  xml_content = file("./api/base_policy.xml")

  #product_ids           = [module.idpay_api_io_product.product_id]
  #subscription_required = true

  api_operation_policies = [
    {
      operation_id = "userPermission"
      xml_content = templatefile("./api/idpay_role_permission/get-permission-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
        jwt_cert_signing_kv_id = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.name
      })
    }
  ]

}
