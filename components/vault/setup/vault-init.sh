#! /bin/bash

NAMESPACE="vault"
TARGET=$1
if [[ $TARGET == "baremetal" ]]
then
    POD="vault-helm-baremetal-0"
else
    POD="vault-helm-0"
fi

# Initialize Vault
printf "[+] Initializing Vault...\n"
kubectl -n ${NAMESPACE} exec ${POD} -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json

VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl -n ${NAMESPACE} exec ${POD} -- vault operator unseal $VAULT_UNSEAL_KEY

VAULT_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")
printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
printf "[!] ROOT TOKEN: ${VAULT_ROOT_TOKEN}\n"
printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"

# Configure Kubernetes Authentication
printf "[+] Configuring Kubernetes Authentication...\n"
kubectl -n ${NAMESPACE} exec ${POD} -- vault login $VAULT_ROOT_TOKEN
kubectl -n ${NAMESPACE} exec ${POD} -- vault auth enable kubernetes

kubectl -n ${NAMESPACE} exec ${POD} -- vault write auth/kubernetes/config \
    token_reviewer_jwt=@/var/run/secrets/kubernetes.io/serviceaccount/token \
    kubernetes_host="https://kubernetes.default.svc.cluster.local:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
