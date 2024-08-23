# Build stage
FROM debian:12.6-slim AS builder

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
ARG TARGETARCH
RUN case ${TARGETARCH} in \
    "amd64")  AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" ;; \
    "arm64")  AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" ;; \
    *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac && \
    curl "${AWSCLI_URL}" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --install-dir /aws-cli --bin-dir /aws-cli-bin

# Final stage
FROM debian:12.6-slim

# Install cron
RUN apt-get update && apt-get install -y \
    cron \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /aws-cli /aws-cli
COPY --from=builder /aws-cli-bin /usr/local/bin

COPY s3.sh mysqldump-to-s3.sh restore-mysql-rsync-s3.sh pgdump-to-s3.sh gzipped-s3.sh bzipped-s3.sh /
RUN chmod a+x /*.sh

WORKDIR /data
ENTRYPOINT []
CMD ["/bin/bash"]
