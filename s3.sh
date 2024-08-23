#!/bin/bash
set -euo pipefail

# Check required environment variables
: "${ORIGIN:?ORIGIN must be set}"
: "${DESTINATION:?DESTINATION must be set}"

# Set default values
STORAGE_CLASS=${STORAGE_CLASS:-STANDARD}
COMPRESSION_TYPE=${COMPRESSION_TYPE:-gzip}
SYNC_ONLY=${SYNC_ONLY:-false}
S3_EXTRA_ARGS=${S3_EXTRA_ARGS:-}

# Set compression-specific variables
case "$COMPRESSION_TYPE" in
  gzip)
    COMPRESS_EXT=".gz"
    TAR_OPTS="czf"
    ;;
  bzip2)
    COMPRESS_EXT=".bz2"
    TAR_OPTS="cjf"
    ;;
  *)
    echo "Invalid COMPRESSION_TYPE. Use 'gzip' or 'bzip2'."
    exit 1
    ;;
esac

if [ "$SYNC_ONLY" = "true" ]; then
    echo "Syncing files to S3..."
    aws s3 sync "$ORIGIN" "s3://${DESTINATION}" \
        --storage-class "$STORAGE_CLASS" \
        "$S3_EXTRA_ARGS"
else
    DATE=$(date +%Y%m%d-%H%M%S)
    BACKUP_FILE="/${ORIGIN}.${DATE}.tar${COMPRESS_EXT}"

    echo "Creating compressed backup..."
    tar $TAR_OPTS "$BACKUP_FILE" "$ORIGIN"

    echo "Uploading backup to S3..."
    aws s3 cp "$BACKUP_FILE" "s3://${DESTINATION}" \
        --storage-class "$STORAGE_CLASS" \
        "$S3_EXTRA_ARGS"

    echo "Cleaning up local backup file..."
    rm "$BACKUP_FILE"
fi
