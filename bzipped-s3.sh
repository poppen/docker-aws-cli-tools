#!/bin/ash

set -eu

DATE=`date +%Y%m%d-%H%M%S`

tar cjf /${ORIGIN}.${DATE}.tar.bz2 ${ORIGIN}
aws s3 cp /${ORIGIN}.${DATE}.tar.bz2 s3://${DESTINATION} --storage-class ${STORAGE_CLASS:-STANDARD}
rm /${ORIGIN}.${DATE}.tar.bz2
