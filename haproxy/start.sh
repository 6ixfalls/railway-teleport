#!/bin/sh

set -e

export TERM=ansi

_RED=$(tput setaf 1)
_RESET=$(tput sgr0)

write_red() {
  echo ${_RED}${1}${_RESET}
}

if [[ $PROXY_HOST != *.railway.internal ]]; then
    write_red "Not a valid host: $PROXY_HOST"
    exit 0
fi

HOST_PORT=${PROXY_HOST}:${PROXY_PORT}

cp -f template.caddyfile Caddyfile

sed -i "s~{HOST_PORT}~$HOST_PORT~g" Caddyfile

caddy fmt --overwrite Caddyfile

exec caddy run --config Caddyfile --adapter caddyfile 2>&1