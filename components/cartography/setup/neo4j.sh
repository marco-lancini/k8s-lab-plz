#!/bin/bash

NAMESPACE=$1
TARGET=$2
SELECTOR=$3

VAULT_NAMESPACE="vault"
VAULT_SELECTOR="app.kubernetes.io/name=vault,component=server"
VAULT_POD_NAME=$(plz run //common:get_resource_from_selector ${VAULT_NAMESPACE} pod ${VAULT_SELECTOR})
NEO4J_PASSWORD_LOCATION="secret/cartography/neo4j-password"
NEO4J_PASSWORD=$(openssl rand -base64 32)

# Neo4j Password
printf "\n[+] Generating and persisting Neo4j password...\n"
printf "\n[+] Generating Neo4j Password and persisting it into Vault at: ${NEO4J_PASSWORD_LOCATION}\n"
# With -cas=0 a write will only be allowed if the key doesn't exist
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -it -- vault kv put -cas=0 ${NEO4J_PASSWORD_LOCATION} NEO4J_SECRETS_PASSWORD=${NEO4J_PASSWORD}

# Deploy Neo4j:
#   - Generate TLS Certificates and Ingress (baremetal only)
#   - Create StorageClass and PersistentVolume (baremetal only)
#   - Deploy the Neo4j StatefulSet, Service, and Ingress
printf "\n[+] Deploying Neo4j...\n"
if [[ $TARGET == "baremetal" ]]
then
    # TLS Certificates
    printf "\n[+] Generating TLS Certificates for Ingress...\n"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/neo4j-tls.key -out /tmp/neo4j-tls.crt -subj "/CN=neo4j.192.168.1.151.nip.io"
    kubectl -n ${NAMESPACE} create secret generic neo4j-bolt-tls --from-file=tls.crt=/tmp/neo4j-tls.crt --from-file=tls.key=/tmp/neo4j-tls.key
    # StorageClass, PersistentVolume, and Ingress
    printf "\n[+] Creating StorageClass, PersistentVolume, and Ingress...\n"
    plz run //components/cartography:neo4j-baremetal_push
fi

printf "\n[+] Deploying Neo4j...\n"
plz run //components/cartography:neo4j_push
plz run //common:wait_pod -- ${NAMESPACE} "Neo4j" ${SELECTOR}
