{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 1,
      "content": {
        "json": "This workbook is intended to show the performance observed during the transaction processing workflow",
        "style": "info"
      },
      "name": "text - 6"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "crossComponentResources": [
          "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
        ],
        "parameters": [
          {
            "id": "54c01aba-36e9-4caf-9291-811ca05fd9f4",
            "version": "KqlParameterItem/1.0",
            "name": "timeRange",
            "type": 4,
            "description": "The time range to search data",
            "isRequired": true,
            "isGlobal": true,
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 900000
                }
              ],
              "allowCustom": true
            },
            "timeContext": {
              "durationMs": 86400000
            },
            "value": {
              "durationMs": 600000,
              "endTime": "2023-02-22T10:38:00.000Z"
            }
          },
          {
            "id": "3f358b66-77ec-4885-94cb-19b8fea5df99",
            "version": "KqlParameterItem/1.0",
            "name": "timeSpan",
            "type": 10,
            "description": "The timespan used to aggregate data",
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n{\"label\": \"500ms\", \"value\": 500, \"selected\": false},\r\n{\"label\": \"1s\", \"value\": 1000, \"selected\": false},\r\n{\"label\": \"10s\", \"value\": 10000, \"selected\": true},\r\n{\"label\": \"30s\", \"value\": 30000, \"selected\": false},\r\n{\"label\": \"1m\", \"value\": 60000, \"selected\": false},\r\n{\"label\": \"2m\", \"value\": 120000, \"selected\": false}\r\n]",
            "timeContext": {
              "durationMs": 86400000
            }
          },
          {
            "id": "3df8ac41-314d-495e-a515-c25c5cafd8cf",
            "version": "KqlParameterItem/1.0",
            "name": "apps",
            "type": 2,
            "description": "The application for which extract performance data",
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n        {\"value\": \"idpay-reward-user-id-splitter\", \"selected\": true},\r\n        {\"value\": \"idpay-reward-calculator\", \"selected\": true},\r\n        {\"value\": \"idpay-transactions\", \"selected\": true},\r\n        {\"value\": \"idpay-wallet\", \"selected\": true},\r\n        {\"value\": \"idpay-reward-notification\", \"selected\": true}\r\n]",
            "defaultValue": "value::all",
            "value": [
              "idpay-reward-user-id-splitter",
              "idpay-reward-calculator",
              "idpay-transactions"
            ]
          },
          {
            "id": "eb9ee305-01c0-415b-a0cb-ba5bd983ebc0",
            "version": "KqlParameterItem/1.0",
            "name": "dbCollections",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ]
            },
            "jsonData": "[\r\n    \r\n                    \"hpan_initiatives_lookup\",\r\n                    \"reward_rule\",\r\n                    \"rewards_notification\",\r\n                    \"transaction\",\r\n                    \"Timeline\",\r\n                    \"transactions_processed\",\r\n                    \"user_initiative_counters\",\r\n                    \"wallet\",\r\n                    \"rewards\",\r\n                    \"initiative_statistics\"\r\n]",
            "defaultValue": "value::all"
          },
          {
            "id": "dc940e06-dccc-4ae1-8470-59486218373b",
            "version": "KqlParameterItem/1.0",
            "name": "flows",
            "type": 2,
            "isRequired": true,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "isHiddenWhenLocked": true,
            "typeSettings": {
              "additionalResourceOptions": [
                "value::all"
              ],
              "showDefault": false
            },
            "jsonData": "[\r\n   {\"label\": \"idpay-reward-user-id-splitter\", \"value\": \"TRX_USERID_SPLITTER\", \"selected\": true},\r\n   {\"label\": \"idpay-reward-calculator\", \"value\": \"REWARD\", \"selected\": true},\r\n   {\"label\": \"idpay-reward-transactions\", \"value\": \"TRANSACTION\", \"selected\": true},\r\n   {\"label\": \"idpay-reward-notification\", \"value\": \"REWARD_NOTIFICATION\", \"selected\": true},\r\n   {\"label\": \"idpay-wallet\", \"value\": \"PROCESS_TRANSACTION\", \"selected\": true}\r\n]",
            "defaultValue": "value::all"
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "Time interval to analyze"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "//PERFORMANCE LOG: Execution statistics\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid, ServiceName\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message, ServiceName\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\ndata\r\n| summarize avg(ms), max(ms), min(ms), stdev(ms), percentile(ms, 95), percentile(ms, 90), count(), startTime=min(timestamp), endTime=max(timestamp) by appName, flow, ServiceName\r\n| join kind=inner (data | summarize tps=count() by appName, flow, bin(timestamp, 1s) | summarize max(tps), avg(tps) by appName, flow) on appName, flow\r\n| join kind=inner (data | summarize maxWorkingPodNumber=count_distinct(PodUid) by appName, flow) on appName, flow\r\n| join kind=inner (KubePodInventory | where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps) | distinct PodUid, ServiceName | summarize totalPodCount=count() by ServiceName) on ServiceName\r\n| project appName, //flow, \r\ncount_, duration=endTime - startTime, avg_ms=toreal((endTime - startTime)/1millis)/count_, avg_ms_single=avg_ms, percentile_ms_95_single=percentile_ms_95, percentile_ms_90_single=percentile_ms_90, min_ms_single=min_ms, max_ms_single=max_ms, stdev_ms_single=stdev_ms, tpm=count_/toreal((endTime - startTime)/1m), avg_tps, max_tps, maxWorkingPodNumber, totalPodCount, startTime, endTime\r\n| sort by array_index_of(apps, appName) asc",
        "size": 1,
        "showAnalytics": true,
        "timeContextFromParameter": "timeRange",
        "showExportToExcel": true,
        "exportToExcelOptions": "all",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "crossComponentResources": [
          "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
        ],
        "visualization": "table",
        "gridSettings": {
          "formatters": [
            {
              "columnMatch": "avg_ms",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "13ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "avg_ms_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "18ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "percentile_ms_95_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "26ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "percentile_ms_90_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "26ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "min_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "max_ms_single",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            },
            {
              "columnMatch": "stdev_ms_single",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "20ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 2,
                  "maximumFractionDigits": 2
                }
              }
            },
            {
              "columnMatch": "tpm",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "14ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "avg_tps",
              "formatter": 0,
              "formatOptions": {
                "customColumnWidthSetting": "14ch"
              },
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "max_tps",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "throughputMinute",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "minimumFractionDigits": 0,
                  "maximumFractionDigits": 0
                }
              }
            },
            {
              "columnMatch": "max_parallelismPerSecond",
              "formatter": 0,
              "numberFormat": {
                "unit": 0,
                "options": {
                  "style": "decimal"
                }
              }
            }
          ],
          "rowLimit": 5
        }
      },
      "name": "Execution statistics - Copy"
    },
    {
      "type": 1,
      "content": {
        "json": "idpay-wallet print PERFORMANCE_LOG just for rewarded transactions",
        "style": "info"
      },
      "name": "text - 7"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Warning and Errors",
        "expandable": true,
        "items": [
          {
            "type": 1,
            "content": {
              "json": "WARN and ERRORS are obtained checking all the logs/events produced (the logs are restricted to the selected apps), thus it could contains alerts not related to the current logics",
              "style": "info"
            },
            "name": "text - 2"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "// APPLICATION LOGS\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\n// Querying data\r\nlet data = ContainerLog\r\n| where TimeGenerated between(startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| order by timestamp;\r\ndata\r\n| where level in (\"WARN\", \"ERROR\")\r\n| project timestamp, appName, level, message\r\n| sort by timestamp asc",
              "size": 1,
              "timeContextFromParameter": "timeRange",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/microsoft.operationalinsights/workspaces/${prefix}-law"
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "message",
                    "formatter": 0,
                    "formatOptions": {
                      "customColumnWidthSetting": "100%"
                    }
                  }
                ]
              }
            },
            "name": "query - 0"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook725c6cc8-6676-42e5-930c-1469e49d8b4d",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.eventhub/namespaces",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.eventhub/namespaces",
                  "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                  "aggregation": 1,
                  "splitBy": null
                }
              ],
              "title": "Topic errors",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "2",
                  "key": "EntityName",
                  "operator": 0,
                  "values": [
                    "idpay-errors"
                  ]
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Topic errors"
          }
        ]
      },
      "name": "Warning and Errors"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Kafka Metrics",
        "items": [
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "All involved event hubs",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook36ccb4c3-de37-478d-bca4-d39f8de39ac3",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-evh-ns",
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 600000,
                      "endTime": "2023-02-22T10:38:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                        "aggregation": 1,
                        "splitBy": null
                      },
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--OutgoingMessages",
                        "aggregation": 1
                      }
                    ],
                    "title": "Total requests",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "5",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "rtd-trx",
                          "idpay-transaction-user-id-splitter",
                          "idpay-transaction"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "name": "eventhubs incoming-outgoins"
                }
              ]
            },
            "customWidth": "33",
            "name": "all-eventhubs",
            "styleSettings": {
              "maxWidth": "33"
            }
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "idpay-evh-ns-01",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook9a50d864-3896-4c0d-9118-acc13018b273",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 600000,
                      "endTime": "2023-02-22T10:38:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--IncomingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Incoming Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "idpay-transaction",
                          "idpay-transaction-user-id-splitter"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Incoming Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook1f104917-d8f3-4f24-ae7a-b636dd85dd9e",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.eventhub/namespaces",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-msg-rg/providers/Microsoft.EventHub/namespaces/${prefix}-idpay-evh-ns-01"
                    ],
                    "timeContextFromParameter": "timeRange",
                    "timeContext": {
                      "durationMs": 600000,
                      "endTime": "2023-02-22T10:38:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.eventhub/namespaces",
                        "metric": "microsoft.eventhub/namespaces--OutgoingMessages",
                        "aggregation": 1,
                        "splitBy": "EntityName"
                      }
                    ],
                    "title": "Outgoing Messages",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "EntityName",
                        "operator": 0,
                        "values": [
                          "idpay-transaction",
                          "idpay-transaction-user-id-splitter"
                        ]
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Outgoing Messages",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                }
              ]
            },
            "customWidth": "66",
            "name": "idpay-evh-ns-01",
            "styleSettings": {
              "maxWidth": "66"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "Eventhub data shows a different timing with a delay of about 1 minute",
              "style": "warning"
            },
            "name": "text - 3"
          },
          {
            "type": 1,
            "content": {
              "json": "There are 4 consumers reading from the idpay-transactions topic, thus we should expect 4 times outgoing messages on that topic rather than incoming messages\r\n1. idpay-reward-notification\r\n2. idpay-transactions\r\n3. idpay-initiative-statistics\r\n4. idpay-wallet",
              "style": "info"
            },
            "name": "text - 2"
          }
        ]
      },
      "name": "Kafka Metrics"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Processing distribution",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of trx processing\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\n// just intervals having data\r\n//data | summarize avg(ms) by appName, flow, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata | summarize count() by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), appName, flow, count_\r\n// intervals on all appNames, evenif no data \r\n//data | summarize count() by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval | mv-expand appName=apps | extend appName=tostring(appName)) on timestamp, appName | project timestamp=coalesce(timestamp, timestamp1), appName=coalesce(appName, appName1), flow, count_\r\n// no appName distinction\r\n//data | make-series kind=nonempty count() on timestamp from startTimeRounded to endTimeRounded step interval\r\n//| project flow=strcat(appName, \"[\", flow, \"]\"), count_, timestamp\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of trx processing\")",
              "size": 0,
              "showAnalytics": true,
              "title": "Distribution of trx processing",
              "timeContextFromParameter": "timeRange",
              "timeBrushParameterName": "timeRange",
              "showExportToExcel": true,
              "exportToExcelOptions": "all",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "name": "Distribution of trx processing"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of single trx average ms\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\n// just intervals having data\r\n//data | summarize avg(ms) by appName, flow, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata | summarize avg(ms) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), appName, flow, avg_ms\r\n// intervals on all appNames, evenif no data \r\n//data | summarize avg(ms) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval | mv-expand appName=apps | extend appName=tostring(appName)) on timestamp, appName | project timestamp=coalesce(timestamp, timestamp1), appName=coalesce(appName, appName1), flow, avg_ms\r\n// no appName distinction\r\n//data | make-series kind=nonempty avg(ms) on timestamp from startTimeRounded to endTimeRounded step interval\r\n//| project flow=strcat(appName, \"[\", flow, \"]\"), avg_ms, timestamp\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of single trx average ms\")\r\n\r\n",
              "size": 0,
              "aggregation": 3,
              "showAnalytics": true,
              "title": "Distribution of single trx average ms",
              "timeContextFromParameter": "timeRange",
              "timeBrushParameterName": "timeRange",
              "showExportToExcel": true,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "name": "Distribution of single trx average ms"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of commits\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[KAFKA_COMMIT]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[KAFKA_COMMIT\\\\]\\\\[\" flow \"\\\\] Committing \" commitSize:int \" messages\"\r\n| where isnotnull(commitSize);\r\n// just intervals having data\r\n//data | summarize sum(commitSize) by appName, flow, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata | summarize sum(commitSize) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), appName, flow, sum_commitSize\r\n// intervals on all appNames, evenif no data \r\n//data | summarize sum(commitSize) by appName, flow, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval | mv-expand appName=apps | extend appName=tostring(appName)) on timestamp, appName | project timestamp=coalesce(timestamp, timestamp1), appName=coalesce(appName, appName1), flow, sum_commitSize\r\n// no appName distinction\r\n//data | make-series kind=nonempty sum(commitSize) on timestamp from startTimeRounded to endTimeRounded step interval\r\n//| project flow=strcat(appName, \"[\", flow, \"]\"), sum_commitSize, timestamp\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of Kafka messages commits\")\r\n\r\n",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of Kafka messages commits",
              "timeContextFromParameter": "timeRange",
              "timeBrushParameterName": "timeRange",
              "showExportToExcel": true,
              "exportToExcelOptions": "all",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "name": "Distribution of Kafka messages commits"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "//PERFORMANCE LOG: Distribution of trx status\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic(['idpay-transactions']);\r\nlet flows = dynamic(['TRANSACTION']);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[[^\\\\]]+\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\ndata | summarize count() by result=case(message contains \"REWARDED\", \"REWARDED\", \"REJECTED\"), bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), result, count_\r\n| sort by timestamp\r\n| render columnchart with(kind=unstacked, title=\"Distribution of Trx elaboration result\")",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of Trx elaboration result",
              "timeContextFromParameter": "timeRange",
              "showExportToExcel": true,
              "exportToExcelOptions": "all",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "customWidth": "50",
            "name": "Distribution of Trx elaboration result",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "// APPLICATION LOGS\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet data = ContainerLog\r\n| where TimeGenerated between(startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, PodUid, thread, logger, message\r\n| order by timestamp;\r\ndata\r\n| where level in (\"WARN\", \"ERROR\")\r\n| summarize count() by appName, level, bin(timestamp, interval) | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), strcat(level, '[', appName, ']'), count_\r\n| sort by timestamp\r\n| render columnchart with(kind=unstacked, title=\"Distribution of warn/errors\")",
              "size": 1,
              "showAnalytics": true,
              "title": "Distribution of warn/errors",
              "timeContextFromParameter": "timeRange",
              "showExportToExcel": true,
              "exportToExcelOptions": "all",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/microsoft.operationalinsights/workspaces/${prefix}-law"
              ],
              "visualization": "unstackedbar"
            },
            "customWidth": "50",
            "name": "Distribution of warn/errors",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "REWARDED and REJECTED counts are performed on idpay-transactions logs, thus it will be influeced by the number of messages read by that ms",
              "style": "warning"
            },
            "customWidth": "50",
            "name": "RewardedDiscardedDisclaimer",
            "styleSettings": {
              "maxWidth": "59"
            }
          },
          {
            "type": 1,
            "content": {
              "json": "WARN and ERRORS counts are performed checking all the logs produced by the selected apps, thus it could contains alerts not related to the current logics",
              "style": "info"
            },
            "customWidth": "50",
            "name": "ErrorWarnDisclaimer",
            "styleSettings": {
              "maxWidth": "50"
            }
          }
        ]
      },
      "customWidth": "50",
      "name": "Processing distribution",
      "styleSettings": {
        "maxWidth": "50",
        "showBorder": true
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "CosmosDB",
        "items": [
          {
            "type": 10,
            "content": {
              "chartId": "workbook9800e7ab-2761-469e-acda-5e31a232df05",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                  "aggregation": 3,
                  "splitBy": null
                }
              ],
              "title": "Normalized RU Consumption",
              "showOpenInMe": true,
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Normalized RU Consumption",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook1f8e99ae-c423-4a45-bd1f-1af32a298e5e",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequests",
                  "aggregation": 7,
                  "splitBy": "StatusCode"
                }
              ],
              "title": "CosmosDB Errors",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "StatusCode",
                  "operator": 1,
                  "values": [
                    "200",
                    "201",
                    "204",
                    "404",
                    "412",
                    "449",
                    "409"
                  ]
                },
                {
                  "id": "2",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "CosmosDB Errors",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook89a20d0d-3546-4697-84ea-57bc8c285841",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                  "aggregation": 1,
                  "splitBy": "CollectionName"
                }
              ],
              "title": "ComsosDB RU per collection",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "ComsosDB RU"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook09f45975-f4bb-4149-81cf-23689d9ff171",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                  "aggregation": 7,
                  "splitBy": "CommandName"
                }
              ],
              "title": "MongoDB Operation",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "MongoDB Operation"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbookee8cac70-b834-4ee8-bb1f-c26862f8ba5b",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                  "aggregation": 1,
                  "splitBy": "CollectionName"
                }
              ],
              "title": "Data Usage",
              "gridFormatType": 1,
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Subscription",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Name",
                    "formatter": 13,
                    "formatOptions": {
                      "linkTarget": "Resource"
                    }
                  },
                  {
                    "columnMatch": ".*\\/Data Usage$",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Metric",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Aggregation",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Value",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Timeline",
                    "formatter": 9
                  }
                ],
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Data Usage",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook70cc0e90-a02b-4f25-b4da-d6492c754cf7",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-idpay-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-idpay-mongodb-account"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                  "aggregation": 1,
                  "splitBy": "CollectionName"
                }
              ],
              "title": "Document Count",
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "1",
                  "key": "CollectionName",
                  "operator": 0,
                  "valueParam": "dbCollections"
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "name": "Document Count",
            "styleSettings": {
              "maxWidth": "50"
            }
          }
        ]
      },
      "customWidth": "50",
      "name": "CosmosDB",
      "styleSettings": {
        "maxWidth": "50"
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Cluster Metrics",
        "items": [
          {
            "type": 10,
            "content": {
              "chartId": "workbook4ff901ba-f592-405c-b520-5b7c8f17bc06",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.containerservice/managedclusters",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}01-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}01-aks"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_cpu_usage_percentage",
                  "aggregation": 4,
                  "splitBy": "node"
                }
              ],
              "title": "Cluster CPU Usage ",
              "showOpenInMe": true,
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Cluster CPU Usage "
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook3fc01a1c-c9b3-4135-9a95-cfa0513d9af6",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.containerservice/managedclusters",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}01-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}01-aks"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_memory_working_set_percentage",
                  "aggregation": 4,
                  "splitBy": "node"
                }
              ],
              "title": "Cluster Memory Usage",
              "showOpenInMe": true,
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "Cluster Memory Usage"
          }
        ]
      },
      "customWidth": "50",
      "name": "Cluster AKS Metrics",
      "styleSettings": {
        "maxWidth": "50"
      }
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "POD Metrics",
        "items": [
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "Distribution of pods",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "//PERFORMANCE LOG: Distribution of working pods\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\nlet flows = dynamic([{flows:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nlet FlowsMap = (arr: dynamic) {\r\n    toscalar (\r\n    range x from 0 to array_length(arr) - 1 step 1\r\n    | summarize x = make_list(strcat('[', arr[x], ']'))\r\n    )\r\n};\r\nlet data = ContainerLog\r\n| where TimeGenerated between (startTime .. endTime)\r\n| join kind=inner (\r\nKubePodInventory\r\n| where TimeGenerated between (startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct Computer, ContainerID, PodUid, ServiceName\r\n)//KubePodInventory Contains namespace information\r\non Computer, ContainerID\r\n| parse kind=regex flags=U LogEntry with \"^\" timestamp  \"\\\\s\\\\[\" appName \"\\\\]\\\\s\" level \"\\\\s+\\\\[\" thread \"\\\\]\\\\s\\\\[\" logger \"\\\\]\\\\s-\\\\s\" message \"$\"\r\n| project timestamp=datetime_local_to_utc(todatetime(timestamp), \"Europe/Rome\"), level, appName, ServiceName, PodUid, thread, logger, message\r\n| where message startswith \"[PERFORMANCE_LOG]\" and message has_any (FlowsMap(flows))\r\n| parse kind=regex flags=U message with \"^\\\\[PERFORMANCE_LOG\\\\] \\\\[\" flow \"\\\\] Time occurred to perform business logic: \" ms:int \" ms\"\r\n| where isnotnull(ms);\r\n// just intervals having data\r\n//data | summarize count() by PodUid, bin(timestamp, interval)\r\n// intervals having data or empty appName\r\ndata | distinct PodUid, appName, bin(timestamp, interval) | summarize count() by appName, timestamp | join kind=fullouter (range timestamp from startTimeRounded to endTimeRounded step interval) on timestamp | project timestamp=coalesce(timestamp, timestamp1), appName, count_\r\n| order by timestamp desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of working pods\")",
                    "size": 4,
                    "showAnalytics": true,
                    "title": "Distribution of working pods",
                    "timeContextFromParameter": "timeRange",
                    "showExportToExcel": true,
                    "exportToExcelOptions": "all",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
                    ],
                    "visualization": "linechart",
                    "chartSettings": {
                      "showMetrics": false
                    }
                  },
                  "customWidth": "50",
                  "name": "Distribution of working pods",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "//PERFORMANCE LOG: Distribution of working pods\r\n// Configuring timed window search\r\nlet startTime = {timeRange:start};\r\nlet endTime = {timeRange:end};\r\nlet interval = totimespan({timeSpan:label});\r\n// Configuring applications' logs to search\r\nlet apps = dynamic([{apps:value}]);\r\n// Querying data\r\nlet startTimeRounded = bin(startTime, interval);\r\nlet endTimeRounded = bin(endTime, interval);\r\nKubePodInventory\r\n| where TimeGenerated between(startTime .. endTime) and Namespace == \"idpay\" and ServiceName has_any (apps)\r\n| distinct ServiceName, PodUid, TimeGenerated=bin(TimeGenerated, interval)\r\n| summarize totalPodCount=count() by ServiceName, TimeGenerated\r\n| order by TimeGenerated desc\r\n| render columnchart with(kind=unstacked, title=\"Distribution of total pods\")",
                    "size": 4,
                    "showAnalytics": true,
                    "title": "Distribution of total pods",
                    "timeContextFromParameter": "timeRange",
                    "showExportToExcel": true,
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-law"
                    ],
                    "visualization": "linechart",
                    "chartSettings": {
                      "showMetrics": false,
                      "ySettings": {
                        "min": 0
                      }
                    }
                  },
                  "customWidth": "50",
                  "name": "Distribution of total pods",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                }
              ]
            },
            "name": "Distribution of pods"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbookaa6d31c8-539e-4bc2-939d-d5277a8c82b2",
              "version": "MetricsItem/2.0",
              "size": 1,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage",
                  "aggregation": 4,
                  "splitBy": "cloud/roleName"
                }
              ],
              "title": "Process CPU",
              "gridFormatType": 1,
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Name",
                  "formatter": 13
                },
                "leftContent": {
                  "columnMatch": "Value",
                  "formatter": 12,
                  "formatOptions": {
                    "palette": "auto"
                  },
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              },
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "7",
                  "key": "cloud/roleName",
                  "operator": 0,
                  "values": [
                    "idpayonboardingworkflow",
                    "idpaytimeline"
                  ]
                }
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Subscription",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Name",
                    "formatter": 13,
                    "formatOptions": {
                      "linkTarget": "Resource"
                    }
                  },
                  {
                    "columnMatch": "Metric",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Aggregation",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Value",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Timeline",
                    "formatter": 9
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage",
                    "formatter": 1,
                    "numberFormat": {
                      "unit": 1,
                      "options": null
                    }
                  }
                ],
                "rowLimit": 10000,
                "labelSettings": [
                  {
                    "columnId": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage",
                    "label": "Process CPU (Average)"
                  },
                  {
                    "columnId": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentage Timeline",
                    "label": "Process CPU (Average) Timeline"
                  }
                ]
              }
            },
            "name": "Process CPU"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook9847fe68-9cbe-4c35-a52e-7cf90b312f36",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-monitor-rg/providers/Microsoft.Insights/components/${prefix}-appinsights"
              ],
              "timeContextFromParameter": "timeRange",
              "timeContext": {
                "durationMs": 600000,
                "endTime": "2023-02-22T10:38:00.000Z"
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Custom-customMetrics/Heap Memory Used (MB)",
                  "aggregation": 4,
                  "splitBy": "cloud/roleName"
                }
              ],
              "title": "Heap Memory Used (MB)",
              "gridFormatType": 1,
              "showOpenInMe": true,
              "filters": [
                {
                  "id": "2",
                  "key": "cloud/roleName",
                  "operator": 0,
                  "values": [
                    "idpaytimeline",
                    "idpayonboardingworkflow"
                  ]
                }
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Subscription",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Name",
                    "formatter": 13,
                    "formatOptions": {
                      "linkTarget": "Resource"
                    }
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Custom-customMetrics/Heap Memory Used (MB) Timeline",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "microsoft.insights/components/kusto-Custom-customMetrics/Heap Memory Used (MB)",
                    "formatter": 1,
                    "numberFormat": {
                      "unit": 0,
                      "options": null
                    }
                  },
                  {
                    "columnMatch": "Metric",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Aggregation",
                    "formatter": 5
                  },
                  {
                    "columnMatch": "Value",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Timeline",
                    "formatter": 9
                  }
                ],
                "rowLimit": 10000
              }
            },
            "name": "Heap Memory Used (MB)"
          }
        ]
      },
      "customWidth": "50",
      "name": "POD Metrics",
      "styleSettings": {
        "maxWidth": "50"
      }
    }
  ],
  "fallbackResourceIds": [
    "Azure Monitor"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}
