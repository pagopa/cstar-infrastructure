#!/usr/bin/env bash

#
# Based on https://github.com/seppevs/migrate-mongo
# Example:
#   ./mongo-migrate.sh DEV-CSTAR rtd create|up|down
#

BASHDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
WORKDIR="$BASHDIR"

set -e
SUBSCRIPTION=$1
DATABASE=$2
shift 2
other=$@

if [ -z "${SUBSCRIPTION}" ]; then
    printf "\e[1;31mYou must provide a subscription as first argument.\n"
    exit 1
fi

LOCATION="${WORKDIR}/${SUBSCRIPTION}"

if [ ! -d ${LOCATION} ]; then
    printf "\e[1;31mYou must provide a subscription for which a variable file is defined. You provided: '%s'.\n" "${SUBSCRIPTION}" > /dev/stderr
    exit 1
fi

if [ -z "${DATABASE}" ]; then
  printf "\e[1;31mYou must provide a database name\n"
      exit 1
fi

# TODO: az account set -s "${SUBSCRIPTION}"

# TODO: add scripts to get connection MONGO URI from azure

docker run --rm -it --network=host \
  -v ${LOCATION}:/app \
  -v ${WORKDIR}/migrate-mongo-config.js:/app/migrate-mongo-config.js \
  -e MONGO_URI="mongodb://locahost:21070" \
  -e MONGO_DATABASE=${DATABASE} \
  petretiandrea/migrate-mongo \
  migrate-mongo ${other}