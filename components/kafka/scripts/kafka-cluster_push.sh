#! /bin/bash

NAMESPACE="kafka"

printf "[+] Provision the Apache Kafka cluster\n"
kubectl apply -f https://strimzi.io/examples/latest/kafka/kafka-persistent-single.yaml -n ${NAMESPACE} 
