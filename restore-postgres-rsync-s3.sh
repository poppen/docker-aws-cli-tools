#!/bin/ash
# shellcheck shell=dash
set -e

aws s3 cp s3://${BACKUP_S3_ORIGIN}/`aws s3 ls "${BACKUP_S3_ORIGIN}"/"${POSTGRES_DUMP_LOCATION}"/ --recursive | sort | tail -n 1 | awk '{print $4}'` ./latest.sql.bz2
aws s3 cp s3://${BACKUP_S3_ORIGIN}/`aws s3 ls ${BACKUP_S3_ORIGIN}/${FILE_DUMP_LOCATION}/ --recursive | sort | tail -n 1 | awk '{print $4}'` ./latest.file.tar.bz2

# postgres
PGPASSWORD=${POSTGRES_PASSWORD} psql -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} -d ${POSTGRES_DB} -c "DROP DATABASE ${POSTGRES_DB}; CREATE DATABASE ${POSTGRES_DB} ${POSTGRES_EXTRA_OPTS}"
bzcat ./latest.sql.bz2 | psql -h ${POSTGRES_HOST} -U ${POSTGRES_USER} -p ${POSTGRES_PORT} -d ${POSTGRES_DB}

# files
tar zxf latest.file.tar.bz2
rsync -a -r --delete ${FILE_ORIGIN} ${FILE_DESTINATION}
aws s3 sync s3://${DATA_S3_ORIGIN} s3://${DATA_S3_DESTINATION} --delete
