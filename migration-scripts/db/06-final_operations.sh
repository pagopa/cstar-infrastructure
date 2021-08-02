#!/usr/bin/env bash

curr_env=$1

if [ ! -f ".env.${curr_env}" ] 
then
    echo "File .env.${curr_env} DOES NOT exists."
    exit 1
fi

# shellcheck disable=SC1090
source ".env.${curr_env}"

### psql dir

cd "../../src/psql/" || exit

# shellcheck disable=SC2154
bash flyway.sh migrate "${subscription}" bpd -target=3
bash flyway.sh info "${subscription}" bpd
