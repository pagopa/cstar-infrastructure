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

bash flyway.sh info "${subscription}" postgres
bash flyway.sh migrate "${subscription}" postgres -target=1
bash flyway.sh migrate "${subscription}" postgres -target=2

bash flyway.sh info "${subscription}" bpd
bash flyway.sh migrate "${subscription}" bpd -target=1
bash flyway.sh migrate "${subscription}" bpd -target=2

bash flyway.sh info "${subscription}" fa
bash flyway.sh migrate "${subscription}" fa -target=1
bash flyway.sh migrate "${subscription}" fa -target=2

bash flyway.sh info "${subscription}" rtd
bash flyway.sh migrate "${subscription}" rtd -target=1
bash flyway.sh migrate "${subscription}" rtd -target=2
