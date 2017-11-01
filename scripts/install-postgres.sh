#!/usr/bin/env bash

VERSION=10
DATABASE=project_name
DATABASE_PASSWORD=xxx
POSTGRES_PASSWORD=xxx

sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -

sudo apt-get update

sudo apt-get install -y postgresql-${VERSION} postgresql-contrib-${VERSION}

echo ""
echo "INFO: Setting postgres role password.."

sudo passwd postgres

echo ""
echo "INFO: Configuring postgresql.."

sudo su postgres <<EOF
psql -d template1 -c "ALTER ROLE postgres WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';"
psql -d template1 -c "CREATE USER DATABASE WITH ENCRYPTED PASSWORD '$DATABASE_PASSWORD';"
psql -d template1 -c "CREATE DATABASE DATABASE;"
psql -d template1 -c "GRANT ALL PRIVILEGES ON DATABASE DATABASE TO DATABASE;"
EOF

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
