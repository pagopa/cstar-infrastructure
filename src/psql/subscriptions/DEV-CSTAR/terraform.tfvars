env             = "dev"
env_short       = "d"
psql_servername = "cstar-d-postgresql"

users = [
  {
    name     = "BPD_USER"
    password = null
    grants = [
      {
        object_type : "table"
        schema: "bpd_award_period"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        schema: "bpd_citizen"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        schema: "bpd_dashboard_pagopa"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        schema: "bpd_error_record"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        schema: "bpd_mcc_category"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        schema: "bpd_payment_instrument"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type : "table"
        schema: "bpd_winning_transaction"
        privileges : ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
    ]
  },
]
