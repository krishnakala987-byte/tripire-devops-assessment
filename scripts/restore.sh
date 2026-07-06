#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: ./scripts/restore.sh <backup_file.sql>"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Dropping existing schema..."

docker exec -i tripire-postgres psql \
    -U postgres \
    -d hoteldb \
    -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

echo "Restoring backup..."

docker exec -i tripire-postgres psql \
    -U postgres \
    -d hoteldb \
    < "$BACKUP_FILE"

echo "Restore completed successfully."