#! /bin/bash

POLICY_FILE="components/vault/setup/agent-policy.json"

# Create role for the sidecar
printf "[+] Creating role for the Vault Sidecar...\n"
kubectl -n vault exec vault-helm-0 -- vault secrets enable -path=secret kv-v2

# Create policy for the sidecar
printf "[+] Creating policy for the Vault Sidecar...\n"
POLICY=$(cat ${POLICY_FILE})
kubectl -n vault exec vault-helm-0 -- /bin/sh -c "echo '$POLICY' > /tmp/policy.json"
kubectl -n vault exec vault-helm-0 -- vault policy write vault-agent /tmp/policy.json
kubectl -n vault exec vault-helm-0 -- vault write \
        auth/kubernetes/role/vault-agent \
        bound_service_account_names=vault-agent \
        bound_service_account_namespaces=default \
        policies=vault-agent \
        ttl=24h
