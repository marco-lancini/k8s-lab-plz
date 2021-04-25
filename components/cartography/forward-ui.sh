#! /bin/bash

NAMESPACE="cartography"
SELECTOR="app=cartography,component=neo4j,service=http"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

SERVICE_NAME=$(plz run //common:get_resource_from_selector ${NAMESPACE} svc ${SELECTOR})

printf "[+] Forwarding Neo4J UI to http://127.0.0.1:7474\n"
kubectl -n ${NAMESPACE} port-forward svc/${SERVICE_NAME} 7474:7474 7473:7473 7687:7687
