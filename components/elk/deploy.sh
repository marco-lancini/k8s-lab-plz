#! /bin/bash

NAMESPACE="elastic"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

# Create `elastic` namespace
printf "\n[+] Creating ${NAMESPACE} namespace...\n"
plz run //components/elk:elk-namespace_push

#
# Deploying ELK:
#   - Elasticsearch cluster
#   - Kibana instance
#
printf "\n[+] Deploying ELK on ${TARGET}...\n"
if [[ $TARGET == "baremetal" ]]
then
    plz run //components/elk:elk-baremetal_push
else
    plz run //components/elk:elk-minikube_push
fi
