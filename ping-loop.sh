#!/bin/bash
#!/sbin/bash
#!/bin/sh
#!/sbin/sh

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

function pingloopp() {
echo "OK $(date)">>pings.log
httping -c 1 m.youtube.com
httping -c 1 m.facebook.com
httping -c 1 github.com
httping -c 1 www.google.co.id
httping -c 1 instagram.com
}
function loop() {
while true; do
    pingloopp
    sleep 1
  done
}
function run() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Starting ${SERVICE_NAME} service"
  echo -e "Starting ${SERVICE_NAME} service ..."
  screen -AmdS ping-loop "${LIBERNET_DIR}/bin/ping-loop.sh" -l \
    && echo -e "${SERVICE_NAME} service started!"
}

function stop() {
  # write to service log
  "${LIBERNET_DIR}/bin/log.sh" -w "Stopping ${SERVICE_NAME} service"
  echo -e "Stopping ${SERVICE_NAME} service ..."
  kill $(screen -list | grep ping-loop | awk -F '[.]' {'print $1'}) > /dev/null 2>&1
  echo -e "${SERVICE_NAME} service stopped!"
}

function usage() {
  cat <<EOF
Usage:
  -r  Run ${SERVICE_NAME} service
  -s  Stop ${SERVICE_NAME} service
EOF
}

case "${1}" in
  -r)
    run
    ;;
  -s)
    stop
    ;;
  -l)
    loop
    ;;
  *)
    usage
    ;;
esac
