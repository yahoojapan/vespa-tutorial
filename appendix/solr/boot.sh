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
    echo "<INFO> start a docker container for Solr" 1>&2
    sudo docker-compose up -d

    echo "<INFO> wait 10 seconds to ensure ZooKeeper becomes ready" 1>&2
    sleep 10

    echo "<INFO> upload book config to ZooKeeper"
    sudo docker-compose exec solr /bin/bash -c "/opt/solr/server/scripts/cloud-scripts/zkcli.sh -cmd upconfig -zkhost zk:2181 -confdir /solr-sample-apps/config/ -confname book"

    echo "<INFO> create book collection"
    curl 'http://localhost:8983/solr/admin/collections?action=CREATE&name=book&numShards=1&collection.configName=book'

    echo "<INFO> wait until the book collection becomes ready" 1>&2
    local status="0"
    for i in `seq 1 60`; do
        set +e
        status=`curl -XGET -LI -s -o /dev/null -w '%{http_code}\n' 'http://localhost:8983/solr/book/admin/ping'`
        set -e
        if [ "${status}" == "200" ]; then
            break
        fi
        sleep 1
    done
    if [ "${status}" != "200" ]; then
        echo "<ERROR> Solr doesn't become ready after waiting 60 seconds"
        return 1
    fi

    echo "<INFO> feed sample documents and commit" 1>&2
    curl -XPOST -H 'Content-type: application/json' --data-binary @${BASE_DIR}/sample-apps/feed/book-data-put.json 'http://localhost:8983/solr/book/update?commit=true'

    echo "<INFO> done" 1>&2
}

function stop {
    echo "<INFO> stop the running docker container for Solr" 1>&2
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