#!/usr/bin/env bash

### INFO
# https://www.postgresql.org/docs/12/backup-dump.html
# https://helpmanual.io/help/pg_dump/
# https://stackoverflow.com/questions/15692508/a-faster-way-to-copy-a-postgresql-database-or-the-best-way
# requires a virtual machine with 8 vCPU
# set vars on target postgresql
# work_mem = 32MB
# shared_buffers = 4GB
# maintenance_work_mem = 2GB
# full_page_writes = off
# autovacuum = off
# wal_buffers = -1
#
# pg_restore -j 8 --format=d -C -d postgres /tmp/newout.dir/

#### VARS CHANGE ME
dump_dir="/datadrive/dbexport/dump_XXXX"

if [ ! -d "${dump_dir}" ] 
then
    echo "Directory ${dump_dir} DOES NOT exists."
    exit 1
fi

## UAT
# export PGPASSWORD="XXXXXX"
# db_user="XXXX"
# db_host="XXXX"

## PROD
# export PGPASSWORD="XXXXXX"
# db_user="XXXX"
# db_host="XXXX"

#### VARS CHANGE ME

date_restore=$(date +%Y-%m-%d-%H_%M_%S)
log_file="${dump_dir}/log_restore_${date_restore}.txt"
dump_file="${dump_dir}/db.dump"

#### INIT SCRIPT

mkdir -p "${dump_dir}"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore_cstar script start" > "${log_file}"

##############

## fa

db_backup="fa"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} start" >> "${log_file}"

pg_restore -h "${db_host}" -p 5432 -U "${db_user}" -j 8 --format=d -C -d postgres "${dump_file}.${db_backup}/" >> "${log_file}" 2>&1

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} finish" >> "${log_file}"

## rtd

db_backup="rtd"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} start" >> "${log_file}"

pg_restore -h "${db_host}" -p 5432 -U "${db_user}" -j 8 --format=d -C -d postgres "${dump_file}.${db_backup}/" >> "${log_file}" 2>&1

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} finish" >> "${log_file}"

## bpd

db_backup="bpd"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} start" >> "${log_file}"

pg_restore -h "${db_host}" -p 5432 -U "${db_user}" -j 8 --format=d -C -d postgres "${dump_file}.${db_backup}/" >> "${log_file}" 2>&1

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} finish" >> "${log_file}"

##############

CURR_DATE=$(date)
echo "${CURR_DATE} - restore_cstar script finish" >> "${log_file}"
