#! /bin/bash

NAMESPACE="vault"
SELECTOR="app.kubernetes.io/name=vault,component=server"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

# Create `vault` namespace
printf "\n[+] Creating ${NAMESPACE} namespace...\n"
plz run //components/vault:vault-namespace_push

# Deploy Vault
printf "\n[+] Deploying Vault on ${TARGET}...\n"
if [[ $TARGET == "baremetal" ]]
then
    # Create StorageClass and PersistentVolume (baremetal only)
    # Create Ingress
    plz run //components/vault:vault-baremetal-components_push

    # Fetch and deploy the Vault Helm chart
    plz run //components/vault:vault-baremetal-helm_push
else
    # Fetch and deploy the Vault Helm chart
    plz run //components/vault:vault-minikube-helm_push
fi
plz run //common:wait_pod -- ${NAMESPACE} "Vault Operator" ${SELECTOR}

# Initialize Vault and enable Kubernetes backend (will print root token)
printf "\n[+] Initializing Vault...\n"
plz run //components/vault:vault-init ${NAMESPACE} ${TARGET} ${SELECTOR}

# Setup sidecar Agent (create role/policy)
printf "\n[+] Setting up sidecar Agent...\n"
plz run //components/vault:agent-init ${NAMESPACE} ${TARGET} ${SELECTOR}
