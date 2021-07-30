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
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "maintenance_work_mem" --value "2097151"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "work_mem" --value "32768"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "autovacuum" --value "off"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "wal_buffers" --value "-1"
echo "finish update configuration cstar-${environment_short}-postgresql"

echo "start update configuration cstar-${environment_short}-postgresql-rep"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "maintenance_work_mem" --value "2097151"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "work_mem" --value "32768"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "autovacuum" --value "off"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "wal_buffers" --value "-1"
echo "finish update configuration cstar-${environment_short}-postgresql-rep"

sleep 60s

echo "start restart cstar-${environment_short}-postgresql"
az postgres server restart -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql"
echo "finish restart cstar-${environment_short}-postgresql"

echo "start restart cstar-${environment_short}-postgresql-rep"
az postgres server restart -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql-rep"
echo "finish restart cstar-${environment_short}-postgresql-rep"

sleep 120s
