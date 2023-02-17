{
  "location" :"westeurope",
  "properties" : {
    "dataCollectionEndpointId": "${audit_dce_id}",
    "streamDeclarations" : {
      "Custom-IdPayAuditLog_CL" : {
        "columns" : [
          {
            "name" : "TimeGenerated",
            "type" : "datetime"
          },
          {
            "name" : "RawData",
            "type" : "string"
          }
        ]
      }
    },
    "dataSources" : {
      "logFiles" : [
        {
          "name" : "IdPayAuditLog_CL",
          "streams" : [
            "Custom-IdPayAuditLog_CL"
          ],
          "filePatterns" : [
            "/var/log/containers/*"
          ],
          "format" : "text",
          "settings" : {
            "text" : {
              "recordStartTimestampFormat" : "ISO 8601"
            }
          }
        }
      ]
    },
    "destinations" : {
      "logAnalytics" : [
        {
          "workspaceResourceId" : "${log_analytics_workspace_id}",
          "name" : "${log_analytics_workspace_name}"
        }
      ]
    },
    "dataFlows" : [
      {
        "streams" : [
          "Custom-IdPayAuditLog_CL"
        ],
        "destinations" : [
          "${log_analytics_workspace_name}"
        ],
        "transformKql" : "source | extend Log=RawData | where Log contains \"CEF:\"",
        "outputStream" : "Custom-IdPayAuditLog_CL"
      }
    ]
  }
}

