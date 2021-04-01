#! /bin/bash

TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGE="minikube"
fi
if [[ $TARGET == "baremetal" ]]
then
    POD="vault-helm-baremetal-0"
else
    POD="vault-helm-0"
fi

printf "[+] Creating test secret at: secret/database/config\n"
kubectl -n vault exec ${POD} -it -- vault kv put secret/database/config username="db-readonly-username" password="db-secret-password"

printf "[+] Deploying sample deployment...\n"
plz run //components/vault:k8s-sample-deployment_push
