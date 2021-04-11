#! /bin/bash

NAMESPACE=$1
TARGET=$2
SELECTOR=$3
KEY_FILE="cluster-keys-${TARGET}.json"

# Should be:
#   - Baremetal: vault-helm-baremetal-0
#   - Minikube: vault-helm-0
POD_NAME=$(plz run //common:get_resource_from_selector ${NAMESPACE} pod ${SELECTOR})

# Initialize Vault
printf "[+] Initializing Vault...\n"
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault operator init -key-shares=1 -key-threshold=1 -format=json > ${KEY_FILE}

VAULT_UNSEAL_KEY=$(cat ${KEY_FILE} | jq -r ".unseal_keys_b64[]")
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault operator unseal $VAULT_UNSEAL_KEY

VAULT_ROOT_TOKEN=$(cat ${KEY_FILE} | jq -r ".root_token")
printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
printf "[!] ROOT TOKEN: ${VAULT_ROOT_TOKEN}\n"
printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"

# Configure Kubernetes Authentication
printf "[+] Configuring Kubernetes Authentication...\n"
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault login ${VAULT_ROOT_TOKEN}
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault auth enable kubernetes

kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault write auth/kubernetes/config \
    token_reviewer_jwt=@/var/run/secrets/kubernetes.io/serviceaccount/token \
    kubernetes_host="https://kubernetes.default.svc.cluster.local:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
