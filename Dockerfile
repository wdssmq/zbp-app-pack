# syntax=docker/dockerfile:1.4
ARG PHP_VERSION=8.5

FROM php:${PHP_VERSION}-cli-alpine

LABEL org.opencontainers.image.title="Z-BlogPHP App Pack"
LABEL org.opencontainers.image.description="Docker image for packing Z-BlogPHP plugins and themes into ZBA files"
LABEL org.opencontainers.image.source="https://github.com/wdssmq/zbp-app-pack"
LABEL org.opencontainers.image.licenses="MIT"

COPY pack_zba.php /usr/local/bin/pack_zba.php
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && mkdir /workdir \
    && addgroup -S appgroup \
    && adduser -S appuser -G appgroup

WORKDIR /workdir
USER appuser

ENTRYPOINT ["/entrypoint.sh"]
