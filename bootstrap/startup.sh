#!/bin/sh
set -e -x

cat /etc/teleport/apply-on-startup.yaml
teleport start --config=/etc/teleport/teleport.yaml --apply-on-startup=/etc/teleport/apply-on-startup.yaml &

echo "Waiting for start"
sleep 10
echo "Resetting user"
tctl users reset $ADMIN_USER
sleep 2
echo "Exiting server"
exit 0