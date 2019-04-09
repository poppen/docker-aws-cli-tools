#!/bin/ash
# shellcheck shell=dash

set -e

DATE=$(date +%Y%m%d-%H%M%S)

PGPASSWORD=${DATABASE_PASSWORD} pg_dump -c -h${DATABASE_HOST} -p${DATABASE_PORT:-5432} -U${DATABASE_USERNAME} ${DATABASE_EXTRA_OPTS} ${DATABASE_NAME} | bzip2 > /${DATABASE_NAME}.${DATE}.sql.bz2 \
&& aws s3 cp /${DATABASE_NAME}.${DATE}.sql.bz2 s3://${S3_BUCKET}/ --storage-class ${STORAGE_CLASS:-STANDARD}
rm /${DATABASE_NAME}.${DATE}.sql.bz2
