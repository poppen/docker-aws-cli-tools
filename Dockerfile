FROM alpine:3.20

RUN apk add --no-cache \
    bash \
    tzdata \
    aws-cli

COPY s3.sh db-backup-to-s3.sh /
RUN chmod a+x /*.sh

WORKDIR /data

ENTRYPOINT []
CMD ["/bin/bash"]
