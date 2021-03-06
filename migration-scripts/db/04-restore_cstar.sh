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

curr_env=$1

if [ ! -f ".env.${curr_env}" ] 
then
    echo "File .env.${curr_env} DOES NOT exists."
    exit 1
fi

# shellcheck disable=SC1090
source ".env.${curr_env}"

# shellcheck disable=SC2154
if [ ! -d "${dump_dir}" ] 
then
    echo "Directory ${dump_dir} DOES NOT exists."
    exit 1
fi

# shellcheck disable=SC2154
export PGPASSWORD="${pg_password}"

date_restore=$(date +%Y-%m-%d-%H_%M_%S)
# shellcheck disable=SC2154
log_dir="log_restore_${env}_${date_restore}"
timeline_file="${log_dir}/restore_timeline.txt"

#### INIT SCRIPT

mkdir -p "${log_dir}"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore_cstar script start" > "${timeline_file}"

##############

## fa

db_backup="fa"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} start" >> "${timeline_file}"

# shellcheck disable=SC2154
pg_restore -h "${db_host}" -p 5432 -U "${db_user}" -j 8 -d "${db_backup}" "${dump_dir}/${db_backup}" -v 2>&1 | tee "${log_dir}/${db_backup}_data.out"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} finish" >> "${timeline_file}"

## rtd

db_backup="rtd"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} start" >> "${timeline_file}"

pg_restore -h "${db_host}" -p 5432 -U "${db_user}" -j 8 -d "${db_backup}" "${dump_dir}/${db_backup}" -v 2>&1 | tee "${log_dir}/${db_backup}_data.out"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} finish" >> "${timeline_file}"

## bpd

db_backup="bpd"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} start" >> "${timeline_file}"

pg_restore -h "${db_host}" -p 5432 -U "${db_user}" -j 8 -d "${db_backup}" "${dump_dir}/${db_backup}" -v 2>&1 | tee "${log_dir}/${db_backup}_data.out"

CURR_DATE=$(date)
echo "${CURR_DATE} - restore ${db_backup} finish" >> "${timeline_file}"

##############

CURR_DATE=$(date)
echo "${CURR_DATE} - restore_cstar script finish" >> "${timeline_file}"
