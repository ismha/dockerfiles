#!/bin/bash

echo "Starting backup loop..."
while true; do
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  echo "[$TIMESTAMP] Running pg_dump..."

  PGPASSWORD="$POSTGRES_PASSWORD" pg_dump \
    -h postgres18 \
    -p 5432 \
    -U "$POSTGRES_USER" \
    -d "$POSTGRES_DB" \
    -F c \
    -f "/backups/backup_$TIMESTAMP.dump"

  echo "[$TIMESTAMP] Backup complete."

  echo "[$TIMESTAMP] Cleaning up backups older than 7 days..."
  find /backups -type f -name "backup_*.dump" -mtime +7 -exec rm -v {} \;

  sleep 1800  # 30 minutes
done

