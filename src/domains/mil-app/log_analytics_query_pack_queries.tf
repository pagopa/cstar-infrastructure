# ------------------------------------------------------------------------------
# Query for stdout/stdin of mil microservices.
# ------------------------------------------------------------------------------
locals {
  query_display_name = "*** mil -- $${continer_name} - last hour ***"

  query_body = <<-EOF
    ContainerAppConsoleLogs_CL
    | where ContainerName_s == '$${continer_name}'
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
        app_ndc=ParsedJSON.ndc,
        app_hostName=ParsedJSON.hostName,
        app_processId=ParsedJSON.processId
  EOF
}

resource "azurerm_log_analytics_query_pack_query" "mil" {
  for_each      = { for x in local.repositories : x.repository => x }
  query_pack_id = azurerm_log_analytics_query_pack.mil.id
  display_name  = templatestring(local.query_display_name, { continer_name = each.value.repository })
  body          = templatestring(local.query_body, { continer_name = each.value.repository })
}