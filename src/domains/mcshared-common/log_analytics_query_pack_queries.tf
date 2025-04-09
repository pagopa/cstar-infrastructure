# ------------------------------------------------------------------------------
# Query for stdout/stdin of auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_log_analytics_query_pack_query" "auth" {
  query_pack_id = azurerm_log_analytics_query_pack.mcshared.id
  display_name  = "*** mcshared -- auth -- last hour ***"
  body          = <<-EOT
    ContainerAppConsoleLogs_CL
    | where ContainerName_s == 'mil-auth'
    | where time_t > ago(60m)
    | sort by time_t asc
    | extend ParsedJSON = parse_json(Log_s)
    | project 
        app_timestamp=ParsedJSON.timestamp,
        app_sequence=ParsedJSON.sequence,
        app_loggerClassName=ParsedJSON.loggerClassName,
        app_loggerName=ParsedJSON.loggerName,
        app_level=ParsedJSON.level,
        app_message=ParsedJSON.message,
        app_threadName=ParsedJSON.threadName,
        app_threadId=ParsedJSON.threadId,
        app_mdc=ParsedJSON.mdc,
        app_requestId=ParsedJSON.mdc.requestId,
        app_end2endTrxOperationId=ParsedJSON.mdc.traceId,
        app_ndc=ParsedJSON.ndc,
        app_hostName=ParsedJSON.hostName,
        app_processId=ParsedJSON.processId,
        app_exception=ParsedJSON.exception
  EOT
}