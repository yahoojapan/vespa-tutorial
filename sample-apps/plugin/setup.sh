#!/bin/bash
#
# Copyright 2018 Yahoo Japan Corporation.
# Licensed under the terms of the MIT license.
# See LICENSE in the project root.
#

set -eu

PLUGIN_DIR=$(cd $(dirname $0);pwd)
VESPA_VERSION=6.214.72
KL_REPO=https://github.com/yahoojapan/vespa-kuromoji-linguistics.git

if [ -e ${PLUGIN_DIR}/kuromoji-linguistics.jar ]; then
    echo "<INFO> kuromoji-linguistics plugin already exists" 1>&2
else
    echo "<INFO> set up kuromoji-linguistics plugin" 1>&2

    # move to "sample-apps/plugin"
    pushd ${PLUGIN_DIR}

    # get and build kuromoji-linguistics
    git clone ${KL_REPO}
    sudo docker pull maven:3.5.2-jdk-8-slim
    # NOTE: use same version with docker image
    sudo docker run -it --rm \
        -v ${PLUGIN_DIR}/vespa-kuromoji-linguistics:/vespa-kuromoji-linguistics \
        -w /vespa-kuromoji-linguistics maven:3.5.2-jdk-8-slim \
        mvn clean package -DskipTests -Dvespa.version=${VESPA_VERSION}
    sudo ln -s vespa-kuromoji-linguistics/target/kuromoji-linguistics-*-deploy.jar ${PLUGIN_DIR}/kuromoji-linguistics.jar

    # back to the original directory
    popd
fi