#
# IDPAY API
#

resource "azurerm_api_management_api" "devops_idpay_color" {
  name                = "${var.env_short}-devops-idpay-color-envs"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  display_name          = "DevOps IDPAY color"
  path                  = "idpay/color"
  subscription_required = false
  service_url           = "https://dev01.idpay.internal.dev.cstar.pagopa.it/idpay/color"
  protocols             = ["https", "http"]
}

resource "azurerm_api_management_api_policy" "example" {
  api_name            = azurerm_api_management_api.devops_idpay_color.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  xml_content = file("./api/base_policy.xml")
}

resource "azurerm_api_management_api_operation" "devops_idpay_color_get_envs" {
  operation_id        = "get-envs"
  api_name            = azurerm_api_management_api.devops_idpay_color.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "Get Envs variables"
  method              = "GET"
  url_template        = "/app/envs"
  description         = "This url return all envs inside container"

  response {
    status_code = 200
  }
}
