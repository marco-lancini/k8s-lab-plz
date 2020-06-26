#! /bin/bash

# Wait for Vault to be ready
status=$(kubectl -n vault get po vault-helm-0 -o json | jq '.status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for Vault to be ready...\n"
    sleep 5
    status=$(kubectl -n vault get po vault-helm-0 -o json | jq '.status.phase')
done

# Initialize Vault
printf "[+] Initializing Vault...\n"
kubectl -n vault exec vault-helm-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json

VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl -n vault exec vault-helm-0 -- vault operator unseal $VAULT_UNSEAL_KEY

VAULT_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")
printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
printf "[!] ROOT TOKEN: ${VAULT_ROOT_TOKEN}\n"
printf ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"

# Configure Kubernetes Authentication
printf "[+] Configuring Kubernetes Authentication...\n"
kubectl -n vault exec vault-helm-0 -- vault login $VAULT_ROOT_TOKEN
kubectl -n vault exec vault-helm-0 -- vault auth enable kubernetes

kubectl -n vault exec vault-helm-0 -- vault write auth/kubernetes/config \
        token_reviewer_jwt=@/var/run/secrets/kubernetes.io/serviceaccount/token \
        kubernetes_host="https://kubernetes.default.svc.cluster.local:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
