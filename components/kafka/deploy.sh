#! /bin/bash

NAMESPACE="kafka"

wait_pod () {
status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for ${1} to be ready...\n"
    sleep 5
    status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
done
printf "\t[*] ${1} is ready\n"
}

#
# Create namespace
#
printf "[+] Creating kafka namespace...\n"
plz run //components/kafka:kafka-namespace_push

#
# Deploying Kafka Operator
#
printf "[+] Deploying Kafka Operator...\n"
plz run //components/kafka:kafka-operator_push
wait_pod 'Kafka Operator' 'name=strimzi-cluster-operator'

#
# Deploying Kafka cluster (Kafka, Zookeeper, KafkaExporter, Entity Operator)
#
printf "[+] Deploying Kafka cluster...\n"
plz run //components/kafka:kafka-cluster_push
wait_pod 'Zookeeper' 'app.kubernetes.io/name=zookeeper'
wait_pod 'Kafka' 'app.kubernetes.io/name=kafka'
wait_pod 'Entity Operator' 'app.kubernetes.io/name=entity-operator'
wait_pod 'KafkaExporter' 'app.kubernetes.io/name=kafka-exporter'
