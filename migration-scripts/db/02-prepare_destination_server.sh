#!/usr/bin/env bash

curr_env=$1

if [ ! -f ".env.${curr_env}" ] 
then
    echo "File .env.${curr_env} DOES NOT exists."
    exit 1
fi

# shellcheck disable=SC1090
source ".env.${curr_env}"

# shellcheck disable=SC2154
az account set -s "${subscription}"

# shellcheck disable=SC2154
echo "start update configuration cstar-${environment_short}-postgresql"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "maintenance_work_mem" --value "2097151"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "work_mem" --value "32768"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "autovacuum" --value "off"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "wal_buffers" --value "-1"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "pg_stat_statements.track" --value "NONE"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "pg_qs.query_capture_mode" --value "NONE"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql" -n "pgms_wait_sampling.query_capture_mode" --value "NONE"
echo "finish update configuration cstar-${environment_short}-postgresql"

echo "start update configuration cstar-${environment_short}-postgresql-rep"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "maintenance_work_mem" --value "2097151"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "work_mem" --value "32768"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "autovacuum" --value "off"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "wal_buffers" --value "-1"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "pg_stat_statements.track" --value "NONE"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "pg_qs.query_capture_mode" --value "NONE"
az postgres server configuration set -g "cstar-${environment_short}-db-rg" -s "cstar-${environment_short}-postgresql-rep" -n "pgms_wait_sampling.query_capture_mode" --value "NONE"
echo "finish update configuration cstar-${environment_short}-postgresql-rep"

sleep 60s

az postgres server update -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql-rep" --sku-name "MO_Gen5_32"
az postgres server update -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql" --sku-name "MO_Gen5_32"

echo "start restart cstar-${environment_short}-postgresql"
az postgres server restart -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql"
echo "finish restart cstar-${environment_short}-postgresql"

echo "start restart cstar-${environment_short}-postgresql-rep"
az postgres server restart -g "cstar-${environment_short}-db-rg" -n "cstar-${environment_short}-postgresql-rep"
echo "finish restart cstar-${environment_short}-postgresql-rep"

sleep 120s
