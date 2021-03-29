#! /bin/bash

NAMESPACE="vault"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGE="minikube"
fi

wait_pod () {
    status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
    while [ -z "$status" ] || [ $status != '"Running"' ]
    do
        printf "\t[*] Waiting for $1 to be ready...\n"
        sleep 5
        status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
    done
    printf "\t[*] $1 is ready\n"
}

# Deploy Vault:
#   - Create `vault` namespace
#   - Create StorageClass and PersistentVolume (baremetal only)
#   - Fetch and deploy the Vault Helm chart
plz run //components/vault:vault-namespace_push
if [[ $TARGET == "baremetal" ]]
then
    printf "\n[+] Deploying Vault on Baremetal...\n"
    plz run //components/vault:vault-pv-baremetal_push
    plz run //components/vault:vault-helm-baremetal_push
else
    printf "\n[+] Deploying Vault on Minikube...\n"
    plz run //components/vault:vault-helm_push
fi
wait_pod 'Vault Operator' 'app.kubernetes.io/name=vault,component=server'

# Initialize Vault and enable Kubernetes backend (will print root token)
printf "\n[+] Initializing Vault...\n"
plz run //components/vault:vault-init $TARGET

# Setup sidecar Agent (create role/policy)
printf "\n[+] Setting up sidecar Agent...\n"
plz run //components/vault:agent-init $TARGET
plz run //components/vault:agent-service-account_push
