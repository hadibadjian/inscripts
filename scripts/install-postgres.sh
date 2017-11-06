#!/usr/bin/env bash

VERSION=10
POSTGRES_PASSWORD=xxx
DATABASE_NAME=xxx

if [[ "$POSTGRES_PASSWORD" == 'xxx' ]]; then
  echo 'postgres role password not configured.'
  exit
fi

if [[ "$DATABASE_NAME" == 'xxx' ]]; then
  echo 'Database name not configured.'
  exit
fi

sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -

sudo apt-get update

sudo apt-get install -y libpq-dev postgresql-${VERSION} postgresql-contrib-${VERSION}

echo ""
echo "INFO: Setting postgres role password.."

sudo passwd postgres

echo ""
echo "INFO: Configuring postgresql.."

sudo su postgres psql -d template1 -c "ALTER ROLE postgres WITH ENCRYPTED PASSWORD '${POSTGRES_PASSWORD}';"
sudo su postgres psql -d template1 -c "CREATE DATABASE ${DATABASE_NAME};"

echo "
---
INFO: Authenticate remote IPv4 clients:

  file location:
    /etc/postgres/${VERSION}/main/pg_hba.conf

  examples:
    host all all 192.168.0.1/24 scram-sha-256
    host all all 192.168.0.1/24 md5

Only listen to remote addresses you trust:

  file location:
    /etc/postgres/${VERSION}/main/postgres.conf

  examples:
    listen_addresses = '192.168.0.102'
"
