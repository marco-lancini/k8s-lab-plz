#! /bin/bash

NAMESPACE="vault"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi
SELECTOR="app.kubernetes.io/name=vault,component=server"

# Should be:
#   - Baremetal: vault-helm-baremetal-0
#   - Minikube: vault-helm-0
POD_NAME=$(plz run //common:get_resource_from_selector ${NAMESPACE} pod ${SELECTOR})

printf "[+] Creating test secret at: secret/database/config\n"
kubectl -n ${NAMESPACE} exec ${POD_NAME} -it -- vault kv put secret/database/config username="db-readonly-username" password="db-secret-password"

printf "[+] Deploying sample deployment...\n"
plz run //components/vault:k8s-sample-deployment_push
