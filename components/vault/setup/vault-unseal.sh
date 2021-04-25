#! /bin/bash

TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi
NAMESPACE="vault"
SELECTOR="app.kubernetes.io/name=vault,component=server"
KEY_FILE="cluster-keys-${TARGET}.json"

POD_NAME=$(plz run //common:get_resource_from_selector ${NAMESPACE} pod ${SELECTOR})
VAULT_UNSEAL_KEY=$(cat ${KEY_FILE} | jq -r ".unseal_keys_b64[]")
kubectl -n ${NAMESPACE} exec ${POD_NAME} -- vault operator unseal $VAULT_UNSEAL_KEY
