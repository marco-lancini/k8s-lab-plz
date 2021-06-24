#!/bin/bash

TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

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
