# ------------------------------------------------------------------------------
# Container Apps Environment.
# ------------------------------------------------------------------------------
data "azurerm_container_app_environment" "rtp-cae" {
  name                = var.cae_name
  resource_group_name = var.cae_resource_group_name
}

# ------------------------------------------------------------------------------
# Identity for this Container App.
# ------------------------------------------------------------------------------
data "azurerm_user_assigned_identity" "rtp-sender" {
  name                = var.id_name
  resource_group_name = var.id_resource_group_name
}


# ------------------------------------------------------------------------------
# General purpose key vault used to protect secrets.
# ------------------------------------------------------------------------------
data "azurerm_storage_account" "rtp_files_storage_account" {
  name                = local.rtp_files_storage_account_name
  resource_group_name = local.rtp_resource_group_storage_share_name
}

data "azurerm_storage_share" "rtp_jks_file_share" {
  name                 = local.rtp_jks_file_share_name
  storage_account_name = local.rtp_files_storage_account_name
}
