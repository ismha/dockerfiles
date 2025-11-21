#!/bin/bash

# PostgreSQL container and user
CONTAINER="postgres17-dev"
USER="primary_db_admin"

# Backup directory
BACKUP_DIR="./backup_dev_dumpall"
DATE=$(date +%F_%H%M%S)
FILENAME="full_backup_${DATE}.sql.gz"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Run backup
podman exec -t $CONTAINER pg_dumpall -U $USER | gzip > "$BACKUP_DIR/$FILENAME"

# Optional: delete backups older than 7 days
find "$BACKUP_DIR" -name "*.sql.gz" -type f -mtime +7 -exec rm {} \;

# Done!
echo "Full backup completed: $BACKUP_DIR/$FILENAME"


# To restore: gunzip -c "$BACKUP_DIR/$FILENAME" | podman exec -i $CONTAINER psql -U $USER -d POSTGRES_DB


# gunzip -c "/home/hasan/nettyapps/postgres_replication/replica_backup_dumpall/full_backup_2025-07-18.sql.gz" | podman exec -i postgres_primary psql -U primary_db_admin -d postgres #WORKING


#docker exec -u postgres pg17 pg_basebackup -D /backups/basebackup/$(date +%F_%H-%M) -F tar -z -X fetch -P

# podman exec -u primary_db_admin postgres_primary pg_basebackup -D /home/hasan/nettyapps/postgres_replication/primary_backup$(date +%F_%H-%M) -F tar -z -X fetch -P

# podman exec -u primary_db_admin -i postgres_primary -d postgres pg_basebackup -D /home/hasan/nettyapps/postgres_replication/primary_backup$(date +%F_%H-%M) -F tar -z -X fetch -P

# pg_basebackup -h localhost -p 5432 -U primary_db_admin -D "/var/lib/postgresql/backup/full$(date +%F_%H-%M)" -Fp -Xs -P -v

# podman exec -it postgres_primary pg_basebackup -h localhost -p 5432 -U primary_db_admin -D "/var/lib/postgresql/backup/full$(date +%F_%H-%M)" -Fp -Xs -P -v #WORKING!!!

# podman exec -it postgres_primary pg_basebackup -h localhost -p 5432 -U primary_db_admin -D "/var/lib/postgresql/backup/full$(date +%F_%H-%M)" -F tar -z -X fetch -P #WORKING!!!

