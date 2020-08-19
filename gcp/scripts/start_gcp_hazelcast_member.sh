#!/bin/bash
set -x

HZ_VERSION=$1
GCP_VERSION=$2


HZ_JAR_URL=https://repo1.maven.org/maven2/com/hazelcast/hazelcast/${HZ_VERSION}/hazelcast-${HZ_VERSION}.jar
GCP_JAR_URL=https://repo1.maven.org/maven2/com/hazelcast/hazelcast-gcp/${GCP_VERSION}/hazelcast-gcp-${GCP_VERSION}.jar

mkdir -p ${HOME}/jars
mkdir -p ${HOME}/logs

pushd ${HOME}/jars
    echo "Downloading JARs..."
    if wget -q "$HZ_JAR_URL"; then
        echo "Hazelcast JAR downloaded succesfully."
    else
        echo "Hazelcast JAR could NOT be downloaded!"
        exit 1;
    fi

    if wget -q "$GCP_JAR_URL"; then
        echo "GCP Plugin JAR downloaded succesfully."
    else
        echo "GCP Plugin JAR could NOT be downloaded!"
        exit 1;
    fi
popd


CLASSPATH="${HOME}/jars/hazelcast-${HZ_VERSION}.jar:${HOME}/jars/hazelcast-gcp-${GCP_VERSION}.jar:${HOME}/hazelcast.yaml"
nohup java -cp ${CLASSPATH} -server com.hazelcast.core.server.HazelcastMemberStarter >> ${HOME}/logs/hazelcast.stderr.log 2>> ${HOME}/logs/hazelcast.stdout.log &
sleep 5
