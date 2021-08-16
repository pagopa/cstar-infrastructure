env=$1

if [ -z "$env" ]; then
  echo "env should be: dev, uat or prod."
  exit 0
fi

env_short=${env:0:1}
db_server_host=cstar-${env_short}-postgresql.postgres.database.azure.com

az account set -s ${env}-cstar

ADMIN_USER=$(az keyvault secret show -n db-administrator-login --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')
ADMIN_PASSWORD=$(az keyvault secret show -n db-administrator-login-password --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')

echo "ADMIN user: ${ADMIN_USER}"

BPD_USER=$(az keyvault secret show -n db-bpd-login --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')
BPD_PASSWORD=$(az keyvault secret show -n db-bpd-user-password --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')

echo "BPD user: ${BPD_USER}"

RTD_USER=$(az keyvault secret show -n db-rtd-login --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')
RTD_PASSWORD=$(az keyvault secret show -n db-rtd-user-password --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')

echo "RTD user: ${RTD_USER}"

FA_USER=$(az keyvault secret show -n db-fa-login --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')
FA_PASSWORD=$(az keyvault secret show -n db-fa-user-password --vault-name cstar-${env_short}-kv -o tsv | awk '{print $7}')

echo "FA user: ${FA_USER}"


echo "Change BPD username and password"

PGPASSWORD=${ADMIN_PASSWORD}  psql -h ${db_server_host} -u ddsadmin@cstar-u-postgresql -c "ALTER ROLE ${BPD_USER} WITH PASSWORD '${BPD_PASSWORD}';"

echo "Change RTD username and password"

PGPASSWORD=${ADMIN_PASSWORD}  psql -h ${db_server_host} -u ddsadmin@cstar-u-postgresql -c "ALTER ROLE ${RTD_USER} WITH PASSWORD '${RTD_PASSWORD}';"

echo "Change FA username and password"

PGPASSWORD=${ADMIN_PASSWORD}  psql -h ${db_server_host} -u ddsadmin@cstar-u-postgresql -c "ALTER ROLE ${FA_USER} WITH PASSWORD '${FA_PASSWORD}';"

echo "Done !"