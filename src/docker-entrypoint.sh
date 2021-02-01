#!/bin/sh

set -e

# If not set, derive RESOLVER env var at runtime from /etc/resolv.conf
if [ "${RESOLVER}" = "" ]; then
  export RESOLVER="`cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}' | tr '\n' ' '`"
fi

# Run upstream entrypoint
/docker-entrypoint-nginx.sh "$@"
