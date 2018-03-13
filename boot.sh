#!/bin/bash
#
# Copyright 2018 Yahoo Japan Corporation.
# Licensed under the terms of the MIT license.
# See LICENSE in the project root.
#

set -eu

BASE_DIR=$(cd $(dirname $0); pwd)

function usage {
    echo "usage: $0 [start|stop]"
    exit 1
}

function start {
    echo "<INFO> set up plugins if necessary" 1>&2
    sample-apps/plugin/setup.sh

    echo "<INFO> start a docker container for Vespa" 1>&2
    sudo docker-compose up -d

    echo "<INFO> wait until the configuration server becomes ready" 1>&2
    local ret=0
    for i in `seq 1 60`; do
        set +e
        utils/vespa_status config > /dev/null 2>&1
        ret=$?
        set -e
        if [ ${ret} -eq 0 ]; then
            break
        fi
        sleep 1
    done
    if [ ${ret} -ne 0 ]; then
        echo "<ERROR> the configuration server doesn't become ready after waiting 60 seconds"
        return 1
    fi

    echo "<INFO> deploy cluster config to Vespa" 1>&2
    utils/vespa_deploy prepare ${BASE_DIR}/sample-apps/config/cluster
    utils/vespa_deploy activate

    echo "<INFO> wait until all application servers become ready" 1>&2
    for i in `seq 1 60`; do
        set +e
        utils/vespa_status vespa1 vespa2 vespa3 > /dev/null 2>&1
        ret=$?
        set -e
        if [ ${ret} -eq 0 ]; then
            break
        fi
        sleep 1
    done
    if [ ${ret} -ne 0 ]; then
        echo "<ERROR> some of application servers don't become ready after waiting 60 seconds"
        return 1
    fi

    echo "<INFO> feed sample documents" 1>&2
    utils/vespa_feeder sample-apps/feed/book-data-put.json

    echo "<INFO> done" 1>&2
}

function stop {
    echo "<INFO> stop the running docker container for Vespa" 1>&2
    sudo docker-compose down
}


if [ $# -lt 1 ]; then
    usage
fi
if [ `pwd` != ${BASE_DIR} ]; then
    echo "<ERROR> please execute this script in ${BASE_DIR}"
    exit 1
fi

case "$1" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    *)
        usage
        ;;
esac