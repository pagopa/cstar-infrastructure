# ------------------------------------------------------------------------------
# Identity for GitHub used for continuous delivery.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "identity_cd" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-github-cd-id"
  tags                = local.tags
}

# ------------------------------------------------------------------------------
# Identity for payment-notice microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "payment_notice" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-payment-notice-id"
  tags                = local.tags
}

# ------------------------------------------------------------------------------
# Identity for fee-calculator microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "fee_calculator" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-fee-calculator-id"
  tags                = local.tags
}

# ------------------------------------------------------------------------------
# Identity for debt-position microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "debt_position" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-debt-position-id"
  tags                = local.tags
}

# ------------------------------------------------------------------------------
# Identity for idpay microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "idpay" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-idpay-id"
  tags                = local.tags
}

# ------------------------------------------------------------------------------
# Identity for pa-pos microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "pa_pos" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-pa-pos-id"
  tags                = local.tags
}

# ------------------------------------------------------------------------------
# Identity for idpay-ipza-mock microservice.
# ------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "idpay_ipza_mock" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${local.project}-idpay-ipza-mock-id"
  tags                = local.tags
}