#! /bin/bash

NAMESPACE="metrics"

wait_pod () {
status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for $1 to be ready...\n"
    sleep 5
    status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
done
printf "\t[*] $1 is ready\n"
}

#
# Create namespace
#
printf "[+] Creating metrics namespace...\n"
plz run //components/prometheus:metrics-namespace_push

#
# Deploying Prometheus Operator
#
printf "[+] Deploying Prometheus Operator...\n"
plz run //components/prometheus:prometheus-helm_push
wait_pod 'Prometheus Operator' 'app=prometheus-operator-operator'
