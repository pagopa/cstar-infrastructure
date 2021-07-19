#!/usr/bin/env bash

### UAT
# environment_short="u"
# environment="uat"
# subscription="UAT-CSTAR"

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

## Destroy databases

az postgres db delete -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n fa
az postgres db delete -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n rtd
az postgres db delete -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n bpd
