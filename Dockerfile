FROM alpine:3.8

# Versions: https://pypi.python.org/pypi/awscli#downloads
ARG AWS_CLI_VERSION=1.15.65

RUN apk --no-cache update && \
    apk --no-cache add python py-pip py-setuptools ca-certificates mariadb-client rsync tzdata && \
    update-ca-certificates && \
    pip --no-cache-dir install awscli==${AWS_CLI_VERSION}

COPY s3.sh mysqldump-to-s3.sh restore-mysql-rsync-s3.sh gzipped-s3.sh /
RUN chmod a+x /*.sh

WORKDIR /data
ENTRYPOINT []
CMD ["/bin/ash"]
