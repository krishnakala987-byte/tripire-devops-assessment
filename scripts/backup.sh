#!/bin/bash

set -e

BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/hoteldb_${TIMESTAMP}.sql"

mkdir -p "${BACKUP_DIR}"

echo "Creating backup..."

docker exec tripire-postgres pg_dump \
    -U postgres \
    hoteldb > "${BACKUP_FILE}"

echo "Backup created successfully:"
echo "${BACKUP_FILE}"