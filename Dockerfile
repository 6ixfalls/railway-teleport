FROM alpine:3.20 AS config

# Add dockerize for config templating
ENV DOCKERIZE_VERSION=v0.7.0

RUN apk update --no-cache \
    && apk add --no-cache wget openssl \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apk del wget

COPY ./teleport.yaml /teleport.tmpl
ARG CLUSTER_NAME SERVICE_TYPE DATABASE_URL AUTH_SERVER PROXY_TOKEN RAILWAY_TCP_PROXY_DOMAIN RAILWAY_TCP_PROXY_PORT
RUN dockerize -template /teleport.tmpl:/teleport.yaml

ARG TELEPORT_IMAGE=public.ecr.aws/gravitational/teleport-distroless:17.1.1
FROM $TELEPORT_IMAGE AS base
COPY --from=config /teleport.yaml /etc/teleport/teleport.yaml

