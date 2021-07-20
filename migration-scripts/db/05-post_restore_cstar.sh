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

echo "start update configuration cstar-${environment_short}-postgresql"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "maintenance_work_mem"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "work_mem"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "autovacuum"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "wal_buffers"
echo "finish update configuration cstar-${environment_short}-postgresql"

sleep 60s

echo "start restart cstar-${environment_short}-postgresql"
az postgres server restart -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql"
echo "finish restart cstar-${environment_short}-postgresql"
