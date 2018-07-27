#!/bin/ash

set -eu

DATE=`date +%Y%m%d-%H%M%S`

tar czf /${ORIGIN}.${DATE}.tar.gz ${ORIGIN}
aws s3 cp /${ORIGIN}.${DATE}.tar.gz s3://${DESTINATION} --storage-class ${STORAGE_CLASS:-STANDARD}
rm /${ORIGIN}.${DATE}.tar.gz
