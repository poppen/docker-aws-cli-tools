#!/bin/ash

set -eu

DATE=`date +%Y%m%d-%H%M%S`

mysqldump -h ${DATABASE_HOST} -u ${DATABASE_USERNAME} --password=${DATABASE_PASSWORD} ${DATABASE_NAME} | gzip > /${DATABASE_NAME}.${DATE}.sql.gz
aws s3 cp /${DATABASE_NAME}.${DATE}.sql.gz s3://${S3_BUCKET}/ --storage-class ${STORAGE_CLASS:-STANDARD}
