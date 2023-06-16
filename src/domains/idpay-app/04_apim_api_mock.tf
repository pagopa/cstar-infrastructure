#
# IDPAY PRODUCTS
#

module "idpay_api_mock_product" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product?ref=v6.15.2"

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
  url_template        = "/api/v1/messages"
  description         = "Endpoint for mock notificator messages api"
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_notificator_messages_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_mock_notificator_messages.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_notificator_messages.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_notificator_messages.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_notificator_messages.operation_id

  xml_content = templatefile("./api/idpay_mock_api/mock_notificator_messages.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_notificator_messages]

}

## IDPAY Mock Notificator (profiles) ##
resource "azurerm_api_management_api_operation" "idpay_mock_notificator_profiles" {
  operation_id        = "idpay_mock_notificator_profiles"
  api_name            = azurerm_api_management_api.idpay_mock_api.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock notificator profiles"
  method              = "GET"
  url_template        = "/api/v1/profiles/{fiscal_code}"
  description         = "Endpoint for mock notificator profiles api"
  template_parameter {
    name     = "fiscal_code"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_notificator_profiles_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_mock_notificator_profiles.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_notificator_profiles.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_notificator_profiles.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_notificator_profiles.operation_id

  xml_content = templatefile("./api/idpay_mock_api/mock_notificator_profiles.xml.tpl", {
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_notificator_profiles]

}

## IDPAY MOCK BE IO - create service ##
resource "azurerm_api_management_api_operation" "idpay_mock_create_service" {
  operation_id        = "idpay_mock_create_service"
  api_name            = azurerm_api_management_api.idpay_mock_api.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO create services"
  method              = "POST"
  url_template        = "/api/v1/services"
  description         = "Endpoint for mock BE IO create services api"
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_create_service_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_mock_create_service.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_create_service.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_create_service.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_create_service.operation_id

  xml_content = templatefile("./api/idpay_mock_api/mock_create_service.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_create_service]

}

## IDPAY MOCK BE IO - update service ##
resource "azurerm_api_management_api_operation" "idpay_mock_update_service" {
  operation_id        = "idpay_mock_update_service"
  api_name            = azurerm_api_management_api.idpay_mock_api.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO update services"
  method              = "PUT"
  url_template        = "/api/v1/services/{serviceId}"
  description         = "Endpoint for mock BE IO update services api"
  template_parameter {
    name     = "serviceId"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_update_service_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_mock_update_service.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_update_service.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_update_service.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_update_service.operation_id

  xml_content = templatefile("./api/idpay_mock_api/mock_update_service.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_update_service]

}

## IDPAY MOCK BE IO - upload service logo ##
resource "azurerm_api_management_api_operation" "idpay_mock_upload_service_logo" {
  operation_id        = "idpay_mock_upload_service_logo"
  api_name            = azurerm_api_management_api.idpay_mock_api.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO upload services logo"
  method              = "POST"
  url_template        = "/api/v1/services/{serviceId}/logo"
  description         = "Endpoint for mock BE IO upload service logo"
  template_parameter {
    name     = "serviceId"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_upload_service_logo_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_mock_upload_service_logo.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_upload_service_logo.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_upload_service_logo.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_upload_service_logo.operation_id

  xml_content = templatefile("./api/idpay_mock_api/mock_upload_service_logo.xml.tpl", {
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_upload_service_logo]

}

## IDPAY ONE TRUST ##
resource "azurerm_api_management_api_operation" "idpay_mock_tos_version" {
  operation_id        = "idpay_mock_tos_version"
  api_name            = azurerm_api_management_api.idpay_mock_api.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock TOS Version"
  method              = "GET"
  url_template        = "/api/privacynotice/v2/privacynotices/{id}"
  description         = "Endpoint for mock One Trust privacy version"
  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_tos_version_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_mock_tos_version.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_tos_version.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_tos_version.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_tos_version.operation_id

  xml_content = templatefile("./api/idpay_mock_api/mock_tos_version.xml.tpl", {
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_tos_version]

}
