#!/usr/bin/env bash

### INFO
# https://www.postgresql.org/docs/12/backup-dump.html
# https://helpmanual.io/help/pg_dump/
# https://stackoverflow.com/questions/15692508/a-faster-way-to-copy-a-postgresql-database-or-the-best-way
# requires a virtual machine with 8 vCPU

#### VARS CHANGE ME
## UAT
# environment="uat"
# export PGPASSWORD="XXXXXX"
# db_user="XXXX"
# db_host="XXXX"

## PROD
# environment="prod"
# export PGPASSWORD="XXXXXX"
# db_user="XXXX"
# db_host="XXXX"

#### VARS CHANGE ME

date_dump=$(date +%Y-%m-%d-%H_%M_%S)
dump_dir="/datadrive/dbexport/dump_${environment}_${date_dump}"
log_file="${dump_dir}/log_dump.txt"
dump_file="${dump_dir}/db.dump"

#### INIT SCRIPT

mkdir -p "${dump_dir}"

CURR_DATE=$(date)
echo "${CURR_DATE} - dump_cstar script start" > "${log_file}"

##############

## fa

db_backup="fa"

CURR_DATE=$(date)
echo "${CURR_DATE} - dump ${db_backup} start" >> "${log_file}"

pg_dump -h "${db_host}" -p 5432 -U "${db_user}" -j 8 -Fd -d "${db_backup}" -f "${dump_file}.${db_backup}"

CURR_DATE=$(date)
echo "${CURR_DATE} - dump ${db_backup} finish" >> "${log_file}"

## rtd

db_backup="rtd"

CURR_DATE=$(date)
echo "${CURR_DATE} - dump ${db_backup} start" >> "${log_file}"

pg_dump -h "${db_host}" -p 5432 -U "${db_user}" -j 8 -Fd -d "${db_backup}" -f "${dump_file}.${db_backup}"

CURR_DATE=$(date)
echo "${CURR_DATE} - dump ${db_backup} finish" >> "${log_file}"

## bpd

db_backup="bpd"

CURR_DATE=$(date)
echo "${CURR_DATE} - dump ${db_backup} start" >> "${log_file}"

pg_dump -h "${db_host}" -p 5432 -U "${db_user}" -j 8 -Fd -d "${db_backup}" -f "${dump_file}.${db_backup}"

CURR_DATE=$(date)
echo "${CURR_DATE} - dump ${db_backup} finish" >> "${log_file}"

##############

CURR_DATE=$(date)
echo "${CURR_DATE} - dump_cstar script finish" >> "${log_file}"
