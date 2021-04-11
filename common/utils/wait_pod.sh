#! /bin/bash

NAMESPACE=$1
NAME=$2
SELECTOR=$3

wait_pod () {
    status=$(kubectl -n ${NAMESPACE} get pods --selector="${SELECTOR}" -o json | jq '.items[].status.phase')
    while [ -z "$status" ] || [ $status != '"Running"' ]
    do
        printf "\t[*] Waiting for ${NAME} to be ready...\n"
        sleep 5
        status=$(kubectl -n ${NAMESPACE} get pods --selector="${SELECTOR}" -o json | jq '.items[].status.phase')
    done
    printf "\t[*] ${NAME} is ready\n"
}

wait_pod
