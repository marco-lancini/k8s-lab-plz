#! /bin/bash

NAMESPACE="vault"
SELECTOR="app.kubernetes.io/name=vault,component=server"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

# Deploy Vault:
#   - Create `vault` namespace
#   - Create StorageClass and PersistentVolume (baremetal only)
#   - Fetch and deploy the Vault Helm chart
printf "\n[+] Deploying Vault on ${TARGET}...\n"
plz run //components/vault:vault-namespace_push

if [[ $TARGET == "baremetal" ]]
then
    plz run //components/vault:vault-baremetal-pv_push
    plz run //components/vault:vault-baremetal-helm_push
else
    plz run //components/vault:vault-helm_push
fi
plz run //common:wait_pod -- ${NAMESPACE} "Vault Operator" ${SELECTOR}

# Initialize Vault and enable Kubernetes backend (will print root token)
printf "\n[+] Initializing Vault...\n"
plz run //components/vault:vault-init ${NAMESPACE} ${TARGET} ${SELECTOR}

# Setup sidecar Agent (create role/policy)
printf "\n[+] Setting up sidecar Agent...\n"
plz run //components/vault:agent-init ${NAMESPACE} ${TARGET} ${SELECTOR}
