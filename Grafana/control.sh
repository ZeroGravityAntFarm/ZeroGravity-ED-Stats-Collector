#!/bin/bash

name="ed-stats-graf"
port="8010"
ip=""

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

start() {
    if [ ! "$(docker ps -q -f name=$name)" ]; then
        if [ "$(docker ps -aq -f status=exited -f name=$name)" ]; then
            echo "Old container found, removing..."
            docker rm $name
        fi
        docker run -d  --user 1001 --name $name -p $ip:$port:3000 -v "$PWD:/var/lib/grafana" grafana/grafana
    fi
}

stop() {
    docker container kill $name
}

status() {
    docker ps -f name=$name
}

reload() {
    docker kill -s HUP $name
}
case "$1" in
    start)
       start
       ;;
    stop)
       stop
       ;;
    reload)
       reload
       ;;
    status)
       status
       ;;
    *)
       echo "Usage: $0 {start|stop|status|reload}"
esac

exit 0
