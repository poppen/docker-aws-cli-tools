# aws-cli-tools

A Swiss Army knife for various tasks using aws-cli.

## db-backup-to-s3

To dump MySQL or PostgreSQL databases and upload the result to S3.

Environmental variables to set:

* DATABASE_TYPE (required, set to 'mysql' or 'postgresql')
* DATABASE_HOST (required)
* DATABASE_USERNAME (required)
* DATABASE_PASSWORD (required)
* DATABASE_NAME (required)
* S3_BUCKET (required)
* STORAGE_CLASS (optional, default: STANDARD)
* COMPRESSION_TYPE (optional, 'gzip' or 'bzip2', default: bzip2)
* DATABASE_PORT (optional, for PostgreSQL)
* DATABASE_EXTRA_OPTS (optional)
* S3_EXTRA_ARGS (optional)

To run:

```bash
docker run [opts] [env_vars] ghcr.io/poppen/aws-cli-tools /db-backup-to-s3.sh
```

## s3

To sync or backup data to S3.

Environmental variables to set:

* ORIGIN (required)
* S3_BUCKET (required)
* STORAGE_CLASS (optional, default: STANDARD)
* COMPRESSION_TYPE (optional, 'gzip' or 'bzip2', default: bzip2)
* SYNC_ONLY (optional, 'true' or 'false', default: false)
* S3_EXTRA_ARGS (optional)

To run:

```bash
docker run [opts] [env_vars] ghcr.io/poppen/aws-cli-tools /s3.sh
```

## Note

1. The `bzipped-s3.sh` and `gzipped-s3.sh` scripts have been replaced by the unified `s3.sh` script. In the `s3.sh` script, the `DESTINATION` environment variable has been renamed to `S3_BUCKET` for clarity.
2. The `mysqldump-to-s3.sh` and `pgdump-to-s3.sh` scripts have been replaced by the unified `db-backup-to-s3.sh` script, which supports both MySQL and PostgreSQL.
3. The default compression type for both db-backup-to-s3 and s3 scripts is now bzip2.
4. The `restore-mysql-rsync-s3.sh` and `restore-postgres-rsync-s3.sh` scripts have been removed.
5. This project has migrated from DockerHub to GitHub Container Registry (ghcr). Please use `ghcr.io/poppen/aws-cli-tools` instead of `poppen/aws-cli-tools` when pulling the image.
