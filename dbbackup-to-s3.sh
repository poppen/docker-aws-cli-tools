#!/bin/bash
set -euo pipefail

# Check required environment variables
: "${DATABASE_TYPE:?DATABASE_TYPE must be set to 'mysql' or 'postgresql'}"
: "${DATABASE_HOST:?DATABASE_HOST must be set}"
: "${DATABASE_USERNAME:?DATABASE_USERNAME must be set}"
: "${DATABASE_PASSWORD:?DATABASE_PASSWORD must be set}"
: "${DATABASE_NAME:?DATABASE_NAME must be set}"
: "${S3_BUCKET:?S3_BUCKET must be set}"

# Set default values
STORAGE_CLASS=${STORAGE_CLASS:-STANDARD}
COMPRESSION_TYPE=${COMPRESSION_TYPE:-bzip2}
DATABASE_PORT=${DATABASE_PORT:-}
DATABASE_EXTRA_OPTS=${DATABASE_EXTRA_OPTS:-}
S3_EXTRA_ARGS=${S3_EXTRA_ARGS:-}

# Set compression-specific variables
case "$COMPRESSION_TYPE" in
  gzip)
    COMPRESS_CMD="gzip"
    COMPRESS_EXT=".gz"
    ;;
  bzip2)
    COMPRESS_CMD="bzip2"
    COMPRESS_EXT=".bz2"
    ;;
  *)
    echo "Invalid COMPRESSION_TYPE. Use 'gzip' or 'bzip2'."
    exit 1
    ;;
esac

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="/${DATABASE_NAME}.${DATE}.sql${COMPRESS_EXT}"

# Perform database dump based on DATABASE_TYPE
case "$DATABASE_TYPE" in
  mysql)
    echo "Dumping MySQL database..."
    mysqldump -h "$DATABASE_HOST" -u "$DATABASE_USERNAME" --password="$DATABASE_PASSWORD" "$DATABASE_EXTRA_OPTS" "$DATABASE_NAME" | $COMPRESS_CMD > "$BACKUP_FILE"
    ;;
  postgresql)
    echo "Dumping PostgreSQL database..."
    PGPASSWORD="$DATABASE_PASSWORD" pg_dump -c -h "$DATABASE_HOST" ${DATABASE_PORT:+-p "$DATABASE_PORT"} -U "$DATABASE_USERNAME" "$DATABASE_EXTRA_OPTS" "$DATABASE_NAME" | $COMPRESS_CMD > "$BACKUP_FILE"
    ;;
  *)
    echo "Invalid DATABASE_TYPE. Use 'mysql' or 'postgresql'."
    exit 1
    ;;
esac

# Upload to S3
echo "Uploading backup to S3..."
aws s3 cp "$BACKUP_FILE" "s3://${S3_BUCKET}/" --storage-class "$STORAGE_CLASS" "$S3_EXTRA_ARGS"

# Clean up
echo "Cleaning up local backup file..."
rm "$BACKUP_FILE"
