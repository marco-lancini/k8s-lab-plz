#! /bin/bash

NAMESPACE=$1
OBJECT=$2
SELECTOR=$3

name=$(kubectl -n ${NAMESPACE} get ${OBJECT} --selector="${SELECTOR}" -o json | jq -r '.items[].metadata.name')
echo $name
