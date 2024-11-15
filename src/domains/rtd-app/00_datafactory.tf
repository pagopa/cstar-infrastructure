data "azurerm_data_factory" "datafactory" {
  count               = var.enable.rtd_df ? 1 : 0
  name                = "${local.project}-df"
  resource_group_name = "${local.project}-df-rg"
}