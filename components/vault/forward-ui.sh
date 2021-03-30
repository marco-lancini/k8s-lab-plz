#! /bin/bash

TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGE="minikube"
fi
if [[ $TARGET == "baremetal" ]]
then
    SVC="vault-helm-baremetal-ui"
else
    SVC="vault-helm-ui"
fi

VAULT_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")
printf "[+] Forwarding Vault UI to http://127.0.0.1:8200\n"
printf "\t[*] Root Token: ${VAULT_ROOT_TOKEN}\n"
kubectl -n vault port-forward svc/${SVC} 8200
