#! /bin/bash

NAMESPACE="cartography"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGE="minikube"
fi

# wait_pod () {
#     status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
#     while [ -z "$status" ] || [ $status != '"Running"' ]
#     do
#         printf "\t[*] Waiting for $1 to be ready...\n"
#         sleep 5
#         status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
#     done
#     printf "\t[*] $1 is ready\n"
# }

# Setup namespace:
#   - Create `cartography` namespace
#   - Create Vault Agent service account
plz run //components/cartography:cartography-namespace_push
plz run //components/cartography:vault-agent-service-account_push

# Deploy Neo4j:
#   - Create StorageClass and PersistentVolume (baremetal only)
#   - Deploy the Neo4j StatefulSet, Service, and Ingress
plz run //components/cartography:neo4j-pv-baremetal_push
plz run //components/cartography:neo4j_push




# printf"[Neo4j] Generating Certificates and Creating Secrets"
# plz run "$PROJECT_FOLDER"/deployment:local_hault_certs_neo4j

# printf"[Neo4j] Setting up and Deploying Neo4j"
# plz sef deploy-service "$PROJECT_FOLDER"/deployment:neo4j

# printf"[Neo4j] Setup Completed"




# if [[ $TARGET == "baremetal" ]]
# then
#     printf "\n[+] Deploying Vault on Baremetal...\n"
#
#     plz run //components/vault:vault-helm-baremetal_push
# else
#     printf "\n[+] Deploying Vault on Minikube...\n"
#     plz run //components/vault:vault-helm_push
# fi
# wait_pod 'Vault Operator' 'app.kubernetes.io/name=vault,component=server'

# # Initialize Vault and enable Kubernetes backend (will print root token)
# printf "\n[+] Initializing Vault...\n"
# plz run //components/vault:vault-init $TARGET

# # Setup sidecar Agent (create role/policy)
# printf "\n[+] Setting up sidecar Agent...\n"
# plz run //components/vault:agent-init $TARGET
# plz run //components/vault:agent-service-account_push
