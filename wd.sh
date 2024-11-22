#!/bin/bash
set -e

## WD for "when dies". Do something when another machine dies

PINGABLE_URL="$1"
APP_TO_WATCH="$2"

_require_root(){
    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
    fi
}

_require_args(){
    if [ -z "$APP_TO_WATCH" ] || [ -z "$PINGABLE_URL" ];
    then
        echo "Please provide two arguments: $0 IP_OR_URL_TO_PING PROCESS_NAME_TO_WATCH"
        exit
    fi
}


_ping() {
    ping -c 1 $1 > /dev/null 2>&1
}

_time_process_spawn() {
    WATCH_START_TIME=$(date +%s%3N)
    while [ -z "$(ps -A | grep $APP_TO_WATCH)" ];
    do
        echo -ne "waiting $APP_TO_WATCH to start\r"
        sleep 0.1
    done
    WATCH_END_TIME=$(date +%s%3N)
    echo "Took $(($WATCH_END_TIME - $WATCH_START_TIME)) ns to start $APP_TO_WATCH"
}

_main(){
    while $(_ping "$PINGABLE_URL");
    do
        sleep 0.5
        echo -ne "waiting for $PINGABLE_URL to die\r"
    done
    _time_process_spawn
}

_require_root
_require_args
_main