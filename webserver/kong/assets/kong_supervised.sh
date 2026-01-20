#!/bin/bash
#
# Kong Functions
#
startKong() {
    echo "[kongWrapper] Starting Kong..."
    kong start
}

stopKong() {
    echo "[kongWrapper] Caught signal, stopping Kong..."
    kong stop
}

isKongHealthy() {
    kong health >/dev/null 2>&1
    return $?
}

#
# Bootstrap
#
trap stopKong SIGINT SIGTERM SIGQUIT

#
# Main
#
startKong

echo "[kongWrapper] Monitoring for exit signals..."

while true; do
    if ! isKongHealthy; then
        echo "[kongWrapper] Kong is not healthy, exiting wrapper..."
        exit 1
    fi

    sleep 30
done
