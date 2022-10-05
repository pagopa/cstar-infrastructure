resource "azurerm_resource_group" "db_rg" {
  name     = "${local.project}-db-rg"
  location = var.location

  tags = var.tags
}

module "cosmosdb_account" {

  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb_account?ref=v2.15.1"

  name                = "${local.project}-cosmos-db-account"
  location            = azurerm_resource_group.db_rg.location
  resource_group_name = azurerm_resource_group.db_rg.name
  offer_type          = var.cosmos_dbms_params.offer_type
  kind                = var.cosmos_dbms_params.kind
  capabilities        = var.cosmos_dbms_params.capabilities
  enable_free_tier    = var.cosmos_dbms_params.enable_free_tier


  public_network_access_enabled     = var.cosmos_dbms_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_dbms_params.private_endpoint_enabled
  subnet_id                         = data.azurerm_subnet.private_endpoint_snet.id
  private_dns_zone_ids              = [data.azurerm_private_dns_zone.cosmos.id]
  is_virtual_network_filter_enabled = var.cosmos_dbms_params.is_virtual_network_filter_enabled

  allowed_virtual_network_subnet_ids = [
    data.azurerm_subnet.private_endpoint_snet.id
  ]

  ip_range = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"

  consistency_policy               = var.cosmos_dbms_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.db_rg.location
  main_geo_location_zone_redundant = var.cosmos_dbms_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_dbms_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_dbms_params.backup_continuous_enabled

  tags = var.tags
}




resource "azurerm_cosmosdb_sql_database" "transaction_aggregate" {

  name                = "tae"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account.name

  throughput = var.cosmos_db_aggregates_params.enable_autoscaling || var.cosmos_db_aggregates_params.enable_serverless ? null : var.cosmos_db_aggregates_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_db_aggregates_params.enable_autoscaling && !var.cosmos_db_aggregates_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_db_aggregates_params.max_throughput
    }
  }
}

resource "azurerm_cosmosdb_sql_container" "aggregates" {

  name                = "aggregates"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_sql_database.transaction_aggregate.name

  partition_key_path    = "/terminalId"
  partition_key_version = 2

  dynamic "autoscale_settings" {
    for_each = var.cosmos_db_aggregates_params.enable_autoscaling && !var.cosmos_db_aggregates_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_db_aggregates_params.max_throughput
    }
  }

}

resource "azurerm_cosmosdb_sql_stored_procedure" "count_aggregates_stored_procedure" {
  name                = "count-stored-proc"
  resource_group_name = azurerm_resource_group.db_rg.name
  account_name        = module.cosmosdb_account.name
  database_name       = azurerm_cosmosdb_sql_database.transaction_aggregate.name
  container_name      = azurerm_cosmosdb_sql_container.aggregates.name

  body = <<BODY
      /**
* This is executed as stored procedure to count the number of docs in the collection.
* To avoid script timeout on the server when there are lots of documents (100K+), the script executed in batches,
* each batch counts docs to some number and returns continuation token.
* The script is run multiple times, starting from empty continuation,
* then using continuation returned by last invocation script until continuation returned by the script is null/empty string.
*
* @param {String} filterQuery - Optional filter for query (e.g. "SELECT * FROM docs WHERE docs.category = 'food'").
* @param {String} continuationToken - The continuation token passed by request, continue counting from this token.
*/
function count(filterQuery, continuationToken) {
    var collection = getContext().getCollection();
    var maxResult = 25; // MAX number of docs to process in one batch, when reached, return to client/request continuation.
                        // intentionally set low to demonstrate the concept. This can be much higher. Try experimenting.
                        // We've had it in to the high thousands before seeing the stored proceudre timing out.

    // The number of documents counted.
    var result = 0;

    tryQuery(continuationToken);

    // Helper method to check for max result and call query.
    function tryQuery(nextContinuationToken) {
        var responseOptions = { continuation: nextContinuationToken, pageSize : maxResult };

        // In case the server is running this script for long time/near timeout, it would return false,
        // in this case we set the response to current continuation token,
        // and the client will run this script again starting from this continuation.
        // When the client calls this script 1st time, is passes empty continuation token.
        if (result >= maxResult || !query(responseOptions)) {
            setBody(nextContinuationToken);
        }
    }

    function query(responseOptions) {
        // For empty query string, use readDocuments rather than queryDocuments -- it's faster as doesn't need to process the query.
        return (filterQuery && filterQuery.length) ?
            collection.queryDocuments(collection.getSelfLink(), filterQuery, responseOptions, onReadDocuments) :
            collection.readDocuments(collection.getSelfLink(), responseOptions, onReadDocuments);
    }

    // This is callback is called from collection.queryDocuments/readDocuments.
    function onReadDocuments(err, docFeed, responseOptions) {
        if (err) {
            throw 'Error while reading document: ' + err;
        }

        // Increament the number of documents counted so far.
        result += docFeed.length;

        // If there is continuation, call query again with it,
        // otherwise we are done, in which case set continuation to null.
        if (responseOptions.continuation) {
            tryQuery(responseOptions.continuation);
        } else {
            setBody(null);
        }
    }

    // Set response body: use an object the client is expecting (2 properties: result and continuationToken).
    function setBody(continuationToken) {
        var body = { count: result, continuationToken: continuationToken };
        getContext().getResponse().setBody(body);
    }
}
BODY
}
