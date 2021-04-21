#!/bin/bash

NAMESPACE=$1
TARGET=$2
SELECTOR=$3

VAULT_NAMESPACE="vault"
VAULT_SELECTOR="app.kubernetes.io/name=vault,component=server"
VAULT_POD_NAME=$(plz run //common:get_resource_from_selector ${VAULT_NAMESPACE} pod ${VAULT_SELECTOR})

# Neo4j Password
NEO4J_PASSWORD_LOCATION="secret/cartography/neo4j-password"
NEO4J_PASSWORD=$(openssl rand -base64 32)
printf "\n[+] Generating Neo4j Password and persisting it into Vault at: ${NEO4J_PASSWORD_LOCATION}\n"

# With -cas=0 a write will only be allowed if the key doesn't exist
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -it -- vault kv put -cas=0 ${NEO4J_PASSWORD_LOCATION} NEO4J_SECRETS_PASSWORD=${NEO4J_PASSWORD}



# NEO4j PASSWORD
printf "\n[+] Generating Neo4j Password and persisting it into Vault at: ${NEO4J_PASSWORD_LOCATION}\n"
VAULT_POD_NAME=$(plz run //common:get_resource_from_selector ${VAULT_NAMESPACE} pod ${VAULT_SELECTOR})
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -it -- vault kv put ${NEO4J_PASSWORD_LOCATION} NEO4J_SECRETS_PASSWORD="$(openssl rand -base64 32)"


# TLS CERTIFICATES
printf "\n[+] Generating TLS Certificates...\n"

