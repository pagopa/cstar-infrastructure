# ------------------------------------------------------------------------------
# Query for stdout/stdin of auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "auth" {
  query_pack_id = azurerm_log_analytics_query_pack.mcshared.id
  display_name  = "*** mcshared -- auth -- last hour ***"
  body          = "ContainerAppConsoleLogs_CL\n| where ContainerName_s == 'mil-auth'\n| where time_t > ago(60m)\n| sort by time_t asc\n| extend ParsedJSON = parse_json(Log_s)\n| project \n    app_timestamp=ParsedJSON.timestamp,\n    app_sequence=ParsedJSON.sequence,\n    app_loggerClassName=ParsedJSON.loggerClassName,\n    app_loggerName=ParsedJSON.loggerName,\n    app_level=ParsedJSON.level,\n    app_message=ParsedJSON.message,\n    app_threadName=ParsedJSON.threadName,\n    app_threadId=ParsedJSON.threadId,\n    app_mdc=ParsedJSON.mdc,\n    app_requestId=ParsedJSON.mdc.requestId,\n    app_ndc=ParsedJSON.ndc,\n    app_hostName=ParsedJSON.hostName,\n    app_processId=ParsedJSON.processId,\n    app_exception=ParsedJSON.exception"
}