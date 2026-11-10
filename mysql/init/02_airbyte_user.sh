#!/bin/bash
# Creates a dedicated, read-only user for Airbyte.
#
# Why a separate user: ingestion tools should never be able to write to the
# source. The REPLICATION grants let it read the binlog for CDC; RELOAD and
# SHOW DATABASES are needed for the initial snapshot.
#
# This is a .sh (not .sql) so it can read the password from the environment
# instead of hardcoding it. It runs once, on first container start.
set -euo pipefail

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
CREATE USER IF NOT EXISTS '${AIRBYTE_DB_USER}'@'%' IDENTIFIED BY '${AIRBYTE_DB_PASSWORD}';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO '${AIRBYTE_DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

echo "Created Airbyte user '${AIRBYTE_DB_USER}'"
