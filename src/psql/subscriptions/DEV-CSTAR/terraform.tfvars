env             = "dev"
env_short       = "d"
psql_servername = "cstar-d-postgresql"

users = [
  {
    name     = "BPD_USER"
    grants = [
      {
        object_type : "table"
        database: "bpd"
        schema: "bpd_award_period"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        database: "bpd"
        schema: "bpd_citizen"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        database: "bpd"
        schema: "bpd_dashboard_pagopa"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        database: "bpd"
        schema: "bpd_error_record"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        database: "bpd"
        schema: "bpd_mcc_category"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        database: "bpd"
        schema: "bpd_payment_instrument"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        database: "bpd"
        schema: "bpd_winning_transaction"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
    ]
  },
]
