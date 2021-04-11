#!/bin/bash

NAMESPACE=$1
TARGET=$2
SELECTOR=$3


# NEO4j PASSWORD
printf "\n[+] Generating Neo4j Password and persisting it into Vault at: ${NEO4J_PASSWORD_LOCATION}\n"
VAULT_POD_NAME=$(plz run //common:get_resource_from_selector ${VAULT_NAMESPACE} pod ${VAULT_SELECTOR})
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -it -- vault kv put ${NEO4J_PASSWORD_LOCATION} NEO4J_SECRETS_PASSWORD="$(openssl rand -base64 32)"


# TLS CERTIFICATES
printf "\n[+] Generating TLS Certificates...\n"

