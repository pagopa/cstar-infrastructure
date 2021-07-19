#!/usr/bin/env bash

### UAT
environment_short="u"
environment="uat"
subscription="UAT-CSTAR"

### PROD
# environment_short="p"
# environment="prod"
# subscription="PROD-CSTAR"

az account set -s "${subscription}"

az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "maintenance_work_mem" --value "2097151"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "work_mem" --value "32768"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "autovacuum" --value "off"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "wal_buffers" --value "-1"

sleep 30s

echo "restarting cstar-${environment_short}-postgresql"
az postgres server restart -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql"

## Destroy and recreate database

# bash terraform.sh init "${environment}" -reconfigure

# bash terraform.sh destroy "${environment}" -target=azurerm_postgresql_database.bpd_db
# bash terraform.sh destroy "${environment}" -target=azurerm_postgresql_database.rtd_db
# bash terraform.sh destroy "${environment}" -target=azurerm_postgresql_database.fa_db

# bash terraform.sh apply "${environment}" -target=azurerm_postgresql_database.bpd_db
# bash terraform.sh apply "${environment}" -target=azurerm_postgresql_database.rtd_db
# bash terraform.sh apply "${environment}" -target=azurerm_postgresql_database.fa_db
