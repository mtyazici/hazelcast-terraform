#!/bin/bash

set -x

MANCENTER_VERSION=$1

mkdir -p ${HOME}/lib
mkdir -p ${HOME}/logs
mkdir -p ${HOME}/man

LOG_DIR=${HOME}/logs
MAN_CENTER_HOME=${HOME}/man

MANCENTER_JAR_URL=https://download.hazelcast.com/management-center/hazelcast-management-center-${MANCENTER_VERSION}.zip

pushd ${HOME}/lib
    echo "Downloading JAR..."
    if wget -q "$MANCENTER_JAR_URL"; then
        echo "Hazelcast Management JAR downloaded succesfully."
    else
        echo "Hazelcast Management JAR could NOT be downloaded!"
        exit 1;
    fi
    unzip hazelcast-management-center-${MANCENTER_VERSION}.zip
    cp hazelcast-management-center-${MANCENTER_VERSION}/* ./

popd


java -cp ${HOME}/lib/hazelcast-management-center-${MANCENTER_VERSION}.jar com.hazelcast.webmonitor.cli.MCConfCommandLine  cluster add -H ${MAN_CENTER_HOME} --client-config ${HOME}/hazelcast-client.yaml \
                       >> $LOG_DIR/mancenter.conf.stdout.log 2>> $LOG_DIR/mancenter.conf.stderr.log


nohup java  -Dhazelcast.mc.home=${MAN_CENTER_HOME} \
             -jar ${HOME}/lib/hazelcast-management-center-${MANCENTER_VERSION}.jar >> $LOG_DIR/mancenter.stdout.log 2>> $LOG_DIR/mancenter.stderr.log &