env             = "prod"
env_short       = "p"
psql_servername = "cstar-p-postgresql"

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
        schema      = "bpd_award_period"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      },
      {
        object_type = "sequence"
        database    = "bpd"
        schema      = "bpd_citizen"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      },
      {
        object_type = "sequence"
        database    = "bpd"
        schema      = "bpd_dashboard_pagopa"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      },
      {
        object_type = "sequence"
        database    = "bpd"
        schema      = "bpd_error_record"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      },
      {
        object_type = "sequence"
        database    = "bpd"
        schema      = "bpd_mcc_category"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      },
      {
        object_type = "sequence"
        database    = "bpd"
        schema      = "bpd_payment_instrument"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      },
      {
        object_type = "sequence"
        database    = "bpd"
        schema      = "bpd_winning_transaction"
        privileges  = ["USAGE", "SELECT", "UPDATE"]
      },
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
  },
  {
    name = "BPD_AWARD_PERIOD_REMOTE_USER"
    grants = [
      {
        object_type = "database"
        database    = "bpd"
        schema      = null
        privileges  = ["CONNECT"]
    }]
  },
  {
    name = "BPD_PAYMENT_INSTRUMENT_REMOTE_USER"
    grants = [
      {
        object_type = "database"
        database    = "bpd"
        schema      = null
        privileges  = ["CONNECT"]
      }
    ]
  },
  {
    name = "BPD_WINNING_TRANSACTION_REMOTE_USER"
    grants = [
      {
        object_type = "database"
        database    = "bpd"
        schema      = null
        privileges  = ["CONNECT"]
      }
    ]
  },
  {
    name = "DASHBOARD_PAGOPA_USER"
    grants = [
      {
        object_type = "database"
        database    = "bpd"
        schema      = null
        privileges  = ["CONNECT", "CREATE", "TEMPORARY"]
      }
    ]
  },
  {
    name = "FA_PAYMENT_INSTRUMENT_REMOTE_USER"
    grants = [
      {
        object_type = "database"
        database    = "fa"
        schema      = null
        privileges  = ["CONNECT"]
      }
    ]
  },
  {
    name = "FA_USER"
    grants = [
      {
        object_type = "database"
        database    = "fa"
        schema      = null
        privileges  = ["CONNECT", "CREATE", "TEMPORARY"]
      },
      {
        object_type = "schema"
        database    = "fa"
        schema      = "fa_customer"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "fa"
        schema      = "fa_merchant"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "fa"
        schema      = "fa_payment_instrument"
        privileges  = ["USAGE"]
      },
      {
        object_type = "schema"
        database    = "fa"
        schema      = "fa_transaction"
        privileges  = ["USAGE"]
      },
      {
        object_type = "table"
        database    = "fa"
        schema      = "fa_customer"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "fa"
        schema      = "fa_merchant"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "fa"
        schema      = "fa_payment_instrument"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
      {
        object_type = "table"
        database    = "fa"
        schema      = "fa_transaction"
        privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
      },
    ]
  },
  {
    name = "MONITORING_USER"
    grants = [
      {
        object_type = "database"
        database    = "bpd"
        schema      = null
        privileges  = ["CONNECT"]
      },
      {
        object_type = "database"
        database    = "fa"
        schema      = null
        privileges  = ["CONNECT"]
      },
      {
        object_type = "database"
        database    = "rtd"
        schema      = null
        privileges  = ["CONNECT"]
      }
    ]
  },
  {
    name   = "tkm_acquirer_manager"
    grants = []
  }
]
