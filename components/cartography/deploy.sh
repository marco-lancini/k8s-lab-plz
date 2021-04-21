#! /bin/bash

NAMESPACE="cartography"
SELECTOR="app=cartography,component=neo4j"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

# Setup namespace:
#   - Create `cartography` namespace
#   - Create Vault Agent service account
printf "\n[+] Deploying Cartography on ${TARGET}...\n"
plz run //components/cartography:cartography-namespace_push
plz run //components/cartography:vault-agent-service-account_push

# Setup and Deploy Neo4j
plz run //components/cartography:deploy-neo4j ${NAMESPACE} ${TARGET} ${SELECTOR}

# Setup and Deploy Cartography
plz run //components/cartography:deploy-cartography ${NAMESPACE} ${TARGET} ${SELECTOR}