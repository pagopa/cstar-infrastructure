data "azurerm_kusto_cluster" "dexp_cluster" {
  count = var.dexp_db.enable ? 1 : 0

  name                = replace("${local.product}dataexplorer", "-", "")
  resource_group_name = var.monitor_resource_group_name
}

resource "azurerm_kusto_database" "database" {
  count = var.dexp_db.enable ? 1 : 0

  name                = "tae"
  resource_group_name = var.monitor_resource_group_name
  location            = data.azurerm_kusto_cluster.dexp_cluster[count.index].location
  cluster_name        = data.azurerm_kusto_cluster.dexp_cluster[count.index].name

  hot_cache_period   = var.dexp_db.hot_cache_period
  soft_delete_period = var.dexp_db.soft_delete_period
}