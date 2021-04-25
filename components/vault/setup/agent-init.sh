#! /bin/bash

NAMESPACE=$1
TARGET=$2
SELECTOR=$3
POLICY_FILE="components/vault/setup/agent-policy.json"

# Should be:
#   - Baremetal: vault-helm-baremetal-0
#   - Minikube: vault-helm-0
POD_NAME=$(plz run //common:get_resource_from_selector ${NAMESPACE} pod ${SELECTOR})

# Enable secret engine
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault secrets enable -path=secret kv-v2
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault write secret/config max_versions=1

# Create policy for the sidecar
printf "[+] Creating policy for the Vault Sidecar...\n"
POLICY=$(cat ${POLICY_FILE})
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- /bin/sh -c "echo '$POLICY' > /tmp/policy.json"
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault policy write vault-agent /tmp/policy.json

# Create role for the sidecar
printf "[+] Creating role for the Vault Sidecar...\n"
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault write \
        auth/kubernetes/role/vault-agent \
        bound_service_account_names=vault-agent \
        bound_service_account_namespaces=* \
        policies=vault-agent \
        ttl=24h
