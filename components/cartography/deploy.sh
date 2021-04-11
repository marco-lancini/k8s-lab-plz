#! /bin/bash

NAMESPACE="cartography"
SELECTOR="app=cartography,component=neo4j"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi
VAULT_NAMESPACE="vault"
VAULT_SELECTOR="app.kubernetes.io/name=vault,component=server"
NEO4J_PASSWORD_LOCATION="secret/cartography/neo4j-password"

# Setup namespace:
#   - Create `cartography` namespace
#   - Create Vault Agent service account
printf "\n[+] Deploying Cartography on ${TARGET}...\n"
plz run //components/cartography:cartography-namespace_push
plz run //components/cartography:vault-agent-service-account_push

# Generate Neo4j Password and store it into Vault
printf "\n[+] Generating Neo4j Password and persisting it into Vault at: ${NEO4J_PASSWORD_LOCATION}\n"
VAULT_POD_NAME=$(plz run //common:get_resource_from_selector ${VAULT_NAMESPACE} pod ${VAULT_SELECTOR})
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -it -- vault kv put ${NEO4J_PASSWORD_LOCATION} NEO4J_SECRETS_PASSWORD="$(openssl rand -base64 32)"

