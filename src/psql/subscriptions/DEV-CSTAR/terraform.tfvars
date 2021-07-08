env             = "dev"
env_short       = "d"
psql_servername = "cstar-d-postgresql"

users = [
  {
    name = "BPD_USER"
    grants = [
      {
        object_type = "schema"
        database    = "bpd"
        schema      = "bpd_award_period"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "bpd"
        schema      = "bpd_citizen"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "bpd"
        schema      = "bpd_dashboard_pagopa"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "bpd"
        schema      = "bpd_error_record"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "bpd"
        schema      = "bpd_mcc_category"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "bpd"
        schema      = "bpd_payment_instrument"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "bpd"
        schema      = "bpd_winning_transaction"
        privileges  = ["USAGE"]
      },
      {
        object_type = "table"
        database    = "bpd"
        schema      = "bpd_award_period"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "bpd"
        schema      = "bpd_citizen"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE"]
      },
      {
        object_type = "table"
        database    = "bpd"
        schema      = "bpd_dashboard_pagopa"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "bpd"
        schema      = "bpd_error_record"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "bpd"
        schema      = "bpd_mcc_category"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "bpd"
        schema      = "bpd_payment_instrument"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "bpd"
        schema      = "bpd_winning_transaction"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "sequence"
        database    = "bpd"
        schema      = "bpd_payment_instrument"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      }
    ]
  },
  {
    name = "RTD_USER"
    grants = [
      {
        object_type = "schema"
        database    = "rtd"
        schema      = "rtd_database"
        privileges  = ["USAGE"]
      },
      {
        object_type = "table"
        database    = "rtd"
        schema      = "rtd_database"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      }
    ]
  }
]
