#! /bin/bash

NAMESPACE="kafka"
PODNAME="kafka-interact-produce"
IMAGE="strimzi/kafka:0.18.0-kafka-2.5.0"
SERVICE="kafka-cluster-kafka-bootstrap:9092"

printf "[+] Starting container...\n"
kubectl -n ${NAMESPACE} run ${PODNAME} -it --rm=true --restart=Never \
        --image=${IMAGE} -- bin/kafka-console-producer.sh            \
        --broker-list ${SERVICE} --topic $1
