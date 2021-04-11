#! /bin/bash

NAMESPACE="vault"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi
KEY_FILE="cluster-keys-${TARGET}.json"
SELECTOR="app.kubernetes.io/name=vault-ui"

# Should be:
#   - Baremetal: vault-helm-baremetal-ui
#   - Minikube: vault-helm-ui
SERVICE_NAME=$(plz run //common:get_resource_from_selector ${NAMESPACE} svc ${SELECTOR})

VAULT_ROOT_TOKEN=$(cat ${KEY_FILE} | jq -r ".root_token")
printf "[+] Forwarding Vault UI to http://127.0.0.1:8200\n"
printf "\t[*] Root Token: ${VAULT_ROOT_TOKEN}\n"
kubectl -n vault port-forward svc/${SERVICE_NAME} 8200
