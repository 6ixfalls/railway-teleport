#!/busybox/sh
set -e -x

teleport start --config=/etc/teleport/teleport.yaml --apply-on-startup=/etc/teleport/apply-on-startup.yaml &

echo "Waiting for start"
while ! echo exit | nc 127.0.0.1 3025; do sleep 10; done
echo "Recieved TCP connection"
if [ ! -z "$NO_RESET_PASSWORD" ] then
  echo "Resetting user"
  tctl users reset $ADMIN_USER
fi
sleep 2
echo "Exiting server"
exit 0
