#!/bin/ash

set -eu

aws s3 sync ${ORIGIN} s3://${DESTINATION} --storage-class ${STORAGE_CLASS:-STANDARD}
