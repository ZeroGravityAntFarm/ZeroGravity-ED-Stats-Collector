#!/bin/bash

#These credentials except the root pass should match the ones in collector.py 
name="ed-stats-mysql"
rootpass=""
user=""
pass=""
db_name=""

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
        docker run --name $name -d -v $PWD/mysql:/var/lib/mysql -e MYSQL_DATABASE=$db_name -e MYSQL_ROOT_PASSWORD=$rootpass -e MYSQL_USER=$user -e MYSQL_PASSWORD=$pass -p 0.0.0.0:3306:3306  mysql:5.7
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
