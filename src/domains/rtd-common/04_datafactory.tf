resource "azurerm_resource_group" "data_factory_rg" {

  count = var.enable.rtd_df ? 1 : 0

  name     = format("%s-df-rg", local.project)
  location = var.location
  tags     = var.tags
}

resource "azurerm_data_factory" "data_factory" {

  count = var.enable.rtd_df ? 1 : 0

  name                   = format("%s-df", local.project)
  location               = azurerm_resource_group.data_factory_rg[count.index].location
  resource_group_name    = azurerm_resource_group.data_factory_rg[count.index].name
  public_network_enabled = false

  # Still doesn't work: https://github.com/hashicorp/terraform-provider-azurerm/issues/12949
  managed_virtual_network_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

locals {
  pe_map = var.enable.rtd_df ? tomap(
    {
      (data.azurerm_storage_account.blobstorage_account.id) = "blob",
      (module.cosmosdb_account_mongodb.id)                  = "MongoDB"
  }) : tomap({})
  df_id   = var.enable.rtd_df ? azurerm_data_factory.data_factory[0].id : null
  df_name = var.enable.rtd_df ? azurerm_data_factory.data_factory[0].name : null
}

resource "azurerm_data_factory_integration_runtime_azure" "autoresolve" {

  count = var.enable.rtd_df ? 1 : 0


  name                    = "AutoResolveIntegrationRuntime"
  data_factory_id         = azurerm_data_factory.data_factory[count.index].id
  location                = "AutoResolve"
  virtual_network_enabled = true
}

resource "azurerm_private_endpoint" "data_factory_pe" {

  count = var.enable.rtd_df ? 1 : 0

  name                = format("%s-pe", azurerm_data_factory.data_factory[count.index].name)
  location            = azurerm_resource_group.data_factory_rg[count.index].location
  resource_group_name = azurerm_resource_group.data_factory_rg[count.index].name
  subnet_id           = data.azurerm_subnet.private_endpoint_snet.id

  private_dns_zone_group {
    name                 = format("%s-private-dns-zone-group", azurerm_data_factory.data_factory[count.index].name)
    private_dns_zone_ids = [data.azurerm_private_dns_zone.adf.id]
  }

  private_service_connection {
    name                           = format("%s-private-service-connection", azurerm_data_factory.data_factory[count.index].name)
    private_connection_resource_id = azurerm_data_factory.data_factory[count.index].id
    is_manual_connection           = false
    subresource_names              = ["datafactory"]
  }

  tags = var.tags
}


resource "azurerm_private_dns_a_record" "data_factory_a_record" {

  count = var.enable.rtd_df ? 1 : 0


  name                = azurerm_data_factory.data_factory[count.index].name
  zone_name           = data.azurerm_private_dns_zone.adf.name
  resource_group_name = data.azurerm_private_dns_zone.adf.resource_group_name
  ttl                 = 300
  records             = azurerm_private_endpoint.data_factory_pe[count.index].private_service_connection.*.private_ip_address

  tags = var.tags
}



resource "azurerm_data_factory_managed_private_endpoint" "managed_pe" {

  for_each = local.pe_map

  name               = replace(format("%s-%s-mng-private-endpoint", local.df_name, substr(sha256(each.key), 0, 3)), "-", "_")
  data_factory_id    = local.df_id
  target_resource_id = each.key
  subresource_name   = each.value

  lifecycle {
    ignore_changes = [
      fqdns
    ]
  }
}

resource "azurerm_role_assignment" "adf_data_contributor_role_on_sa" {

  count = var.enable.rtd_df ? 1 : 0


  scope                = data.azurerm_storage_account.blobstorage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.data_factory[count.index].identity[0].principal_id
}
