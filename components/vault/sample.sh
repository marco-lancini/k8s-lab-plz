#! /bin/bash

printf "[>] Creating test secret at: secret/database/config\n"
kubectl -n vault exec vault-helm-0 -it -- vault kv put secret/database/config username="db-readonly-username" password="db-secret-password"

printf "[>] Deploying sample deployment...\n"
plz run //components/vault:k8s-sample-deployment_push
