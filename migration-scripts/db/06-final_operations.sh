#!/usr/bin/env bash


### UAT
# environment_short="u"
# environment="uat"
# subscription="UAT-CSTAR"

### PROD
# environment_short="p"
# environment="prod"
# subscription="PROD-CSTAR"

### psql dir

cd "../../src/psql/"

bash flyway.sh migrate "${subscription}" bpd -target=3
bash flyway.sh info "${subscription}" bpd
