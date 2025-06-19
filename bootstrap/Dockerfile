FROM alpine:3.22 AS config

# Add dockerize for config templating
ENV DOCKERIZE_VERSION=v0.7.0

RUN apk update --no-cache \
    && apk add --no-cache wget openssl \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apk del wget

COPY ./teleport.yaml /teleport.tmpl
ARG CLUSTER_NAME DATABASE_URL PROXY_TOKEN
RUN dockerize -template /teleport.tmpl:/teleport.yaml
COPY ./apply-on-startup.yaml /apply-on-startup.tmpl
ARG ADMIN_USER
RUN dockerize -template /apply-on-startup.tmpl:/apply-on-startup.yaml

FROM public.ecr.aws/gravitational/teleport-distroless-debug:17.5.2 AS base
COPY --from=config /teleport.yaml /etc/teleport/teleport.yaml
COPY --from=config /apply-on-startup.yaml /etc/teleport/apply-on-startup.yaml
COPY --chmod=777 ./startup.sh /etc/teleport/startup.sh

ENTRYPOINT ["/usr/bin/dumb-init", "/busybox/sh", "-c", "/etc/teleport/startup.sh"]