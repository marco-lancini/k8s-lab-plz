#! /bin/bash

NAMESPACE="elastic-system"
SELECTOR="control-plane=elastic-operator"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

# Create `elastic` namespace
printf "\n[+] Creating ${NAMESPACE} namespace...\n"
plz run //components/elk:elk-namespace_push

#
# Deploying Elastic Operator
#
printf "[+] Deploying Elastic Operator...\n"
plz run //components/elk:eck-crds_push
plz run //components/elk:eck-operator_push
plz run //common:wait_pod -- ${NAMESPACE} "Elastic Operator" ${SELECTOR}

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
