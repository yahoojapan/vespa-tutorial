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
    echo "<INFO> start a docker container for Elasticsearch" 1>&2
    sudo docker-compose up -d

    echo "<INFO> wait until Elasticsearch becomes ready" 1>&2
    local status="0"
    for i in `seq 1 60`; do
        set +e
        status=`curl -XGET -LI -s -o /dev/null -w '%{http_code}\n' 'http://localhost:9200/_cat/health'`
        set -e
        if [ "${status}" == "200" ]; then
            break
        fi
        sleep 1
    done
    if [ "${status}" != "200" ]; then
        echo "<ERROR> Elasticsearch doesn't become ready after waiting 60 seconds"
        return 1
    fi

    echo "<INFO> create book index" 1>&2
    curl -XPUT -H 'Content-type: application/json' --data-binary @${BASE_DIR}/sample-apps/config/schema.json 'http://localhost:9200/book'

    echo "<INFO> feed sample documents" 1>&2
    curl -XPOST -H 'Content-type: application/json' --data-binary @${BASE_DIR}/sample-apps/feed/book-data-put.json 'http://localhost:9200/book/_bulk'

    echo "<INFO> refresh the index" 1>&2
    curl -XPOST 'http://localhost:9200/book/_refresh'

    echo "<INFO> done" 1>&2
}

function stop {
    echo "<INFO> stop the running docker container for Elasticsearch" 1>&2
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