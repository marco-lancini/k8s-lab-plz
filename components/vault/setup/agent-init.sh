#! /bin/bash

NAMESPACE="vault"
POLICY_FILE="components/vault/setup/agent-policy.json"
TARGET=$1
if [[ $TARGET == "baremetal" ]]
then
    POD="vault-helm-baremetal-0"
else
    POD="${POD}"
fi

# Create role for the sidecar
printf "[+] Creating role for the Vault Sidecar...\n"
kubectl -n ${NAMESPACE} exec ${POD} -- vault secrets enable -path=secret kv-v2

# Create policy for the sidecar
printf "[+] Creating policy for the Vault Sidecar...\n"
POLICY=$(cat ${POLICY_FILE})
kubectl -n ${NAMESPACE} exec ${POD} -- /bin/sh -c "echo '$POLICY' > /tmp/policy.json"
kubectl -n ${NAMESPACE} exec ${POD} -- vault policy write vault-agent /tmp/policy.json
kubectl -n ${NAMESPACE} exec ${POD} -- vault write \
        auth/kubernetes/role/vault-agent \
        bound_service_account_names=vault-agent \
        bound_service_account_namespaces=* \
        policies=vault-agent \
        ttl=24h
