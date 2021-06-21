#!/bin/bash

NAMESPACE=$1
TARGET=$2
SELECTOR=$3

# Vault References
VAULT_NAMESPACE="vault"
VAULT_SELECTOR="app.kubernetes.io/name=vault,component=server"
VAULT_POD_NAME=$(plz run //common:get_resource_from_selector ${VAULT_NAMESPACE} pod ${VAULT_SELECTOR})

# Neo4J References
NEO4J_BAREMETAL_HOST="neo4j.192.168.1.151.nip.io"
NEO4J_PASSWORD_LOCATION="secret/cartography/neo4j-password"
NEO4J_PASSWORD=$(openssl rand -base64 32)

# Neo4j Password
printf "\n[+] Generating Neo4j Password and persisting it into Vault at: ${NEO4J_PASSWORD_LOCATION}\n"
# With -cas=0 a write will only be allowed if the key doesn't exist
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -it -- vault kv put -cas=0 ${NEO4J_PASSWORD_LOCATION} NEO4J_SECRETS_PASSWORD=${NEO4J_PASSWORD}

# TLS Certificates
printf "\n[+] Generating TLS Certificates...\n"
if [[ $TARGET == "baremetal" ]]
then
    NEO4J_HOST=$NEO4J_BAREMETAL_HOST
else
    NEO4J_HOST="neo4j-service"
fi
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/neo4j-tls.key -out /tmp/neo4j-tls.crt -subj "/CN=${NEO4J_HOST}"
kubectl -n ${NAMESPACE} create secret generic neo4j-bolt-tls --from-file=tls.crt=/tmp/neo4j-tls.crt --from-file=tls.key=/tmp/neo4j-tls.key

# Deploy Neo4j
#   - Create Vault Agent service account
#   - Create StorageClass and PersistentVolume, and Ingress (baremetal only)
#   - Deploy the Neo4j StatefulSet, Service
printf "\n[+] Deploying Neo4j on ${TARGET}...\n"
if [[ $TARGET == "baremetal" ]]
then
    plz run //components/cartography:neo4j-baremetal_push
else
    plz run //components/cartography:neo4j-minikube_push
fi
plz run //common:wait_pod -- ${NAMESPACE} "Neo4j" ${SELECTOR}
