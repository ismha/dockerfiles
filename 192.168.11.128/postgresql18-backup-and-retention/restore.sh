#!/bin/bash

# === CONFIG ===
CONTAINER_NAME="postgres18"
DB_NAME="my_primary_db"
DB_USER="primary_db_admin"
DUMP_FILE="$1"

# === SAFETY CHECKS ===
if [[ -z "$DUMP_FILE" ]]; then
  echo "Usage: $0 <backup_file.dump>"
  exit 1
fi

if [[ ! -f "$DUMP_FILE" ]]; then
  echo "Error: File '$DUMP_FILE' not found."
  exit 1
fi

echo "About to restore '$DUMP_FILE' into database '$DB_NAME' as user '$DB_USER'."
read -p "Are you sure? This will overwrite existing data. [y/N] " confirm
if [[ "$confirm" != "y" ]]; then
  echo "Restore aborted."
  exit 0
fi

# === EXECUTE RESTORE ===
docker exec -i "$CONTAINER_NAME" pg_restore \
  -U "$DB_USER" \
  -d "$DB_NAME" \
  --clean \
  --create \
  --verbose < "$DUMP_FILE"


# To restore:
# ./restore.sh backups/backup_20251112_193000.dump
