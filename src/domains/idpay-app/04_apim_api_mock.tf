#
# IDPAY PRODUCTS
#

module "idpay_api_mock_product" {
  source = "git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v2.18.2"

  product_id   = "idpay_api_mock_product"
  display_name = "IDPAY_MOCK_PRODUCT"
  description  = "IDPAY_MOCK_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

}

## IDPAY Mock API ##
resource "azurerm_api_management_api" "idpay_mock_api" {
  name                = "${var.env_short}-idpay-mock-api"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  description           = "IDPAY MOCK API"
  display_name          = "IDPAY MOCK API"
  path                  = "idpay/mock"
  protocols             = ["https"]
  subscription_required = false

  depends_on = [module.idpay_api_mock_product]
}

resource "azurerm_api_management_product_api" "idpay_mock_product_api" {
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  api_name            = azurerm_api_management_api.idpay_mock_api.name
  product_id          = module.idpay_api_mock_product.product_id
  depends_on          = [module.idpay_api_mock_product, azurerm_api_management_api.idpay_mock_api]
}


## IDPAY Mock Operations ##
## IDPAY Mock Notificator (messages) ##
resource "azurerm_api_management_api_operation" "idpay_mock_notificator_messages" {
  operation_id        = "idpay_mock_notificator_messages"
  api_name            = azurerm_api_management_api.idpay_mock_api.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock notificator messages"
  method              = "POST"
  url_template        = "/messages"
  description         = "Endpoint for mock notificator api"
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_notificator_messages_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_mock_notificator_messages.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_notificator_messages.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_notificator_messages.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_notificator_messages.operation_id

  xml_content = templatefile("./api/idpay_mock_api/mock_notificator_messages.xml.tpl", {
  })

  depends_on = [azurerm_api_management_api_operation_policy.idpay_token_exchange_policy_test]

}
