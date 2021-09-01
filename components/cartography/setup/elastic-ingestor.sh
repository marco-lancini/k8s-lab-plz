#!/bin/bash

NAMESPACE="cartography"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

#
# Setup Elastic credentials
#
printf "\n[+] Setting up Elastic credentials on ${TARGET}...\n"
NAMESPACE_ELK="elastic-system"
ELASTIC_USER="elastic"
ELASTIC_PASSWORD=$(kubectl -n ${NAMESPACE_ELK} get secrets elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)

kubectl -n ${NAMESPACE} create secret generic elastic-credentials \
  --from-literal=username=${ELASTIC_USER} \
  --from-literal=password=${ELASTIC_PASSWORD}

#
# Deploy Elastic Ingestor:
#   - Deploy the Cartography CronJob
#
printf "\n[+] Deploying Elastic Ingestor on ${TARGET}...\n"
if [[ $TARGET == "baremetal" ]]
then
    plz run //components/cartography:elastic-ingestor-baremetal_push
else
    plz run //components/cartography:elastic-ingestor-minikube_push
fi
