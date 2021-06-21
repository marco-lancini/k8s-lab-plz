#!/bin/bash

NAMESPACE=$1
TARGET=$2
SELECTOR=$3

# Vault References
VAULT_NAMESPACE="vault"
VAULT_SELECTOR="app.kubernetes.io/name=vault,component=server"
VAULT_KEY_FILE="cluster-keys-${TARGET}.json"
VAULT_POD_NAME=$(plz run //common:get_resource_from_selector ${VAULT_NAMESPACE} pod ${VAULT_SELECTOR})

#
# AWS References:
#   - Request user to provide access key, secret key, and Account ID of the Hub
#
ROLE_ASSUME="role_security_assume"
printf "\n[+] Please provide ACCESS KEY for IAM user: "
read ACCESS_KEY
printf "\n[+] Please provide SECRET KEY for IAM user: "
read SECRET_KEY
printf "\n[+] Please provide Account ID of the Hub: "
read HUB_ID

#
# Setup Vault:
#   - Enable the AWS secrets engine
#   - Persist the credentials that Vault will use to communicate with AWS
#   - Configure a Vault role that maps to a set of permissions in AWS
#
printf "[+] Enable the AWS secrets engine...\n"
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -- vault secrets enable aws
printf "[+] Configure the credentials that Vault will us to communicate with AWS...\n"
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -- vault write aws/config/root \
    access_key=${ACCESS_KEY} \
    secret_key=${SECRET_KEY} \
    region=eu-west-1
printf "[+] Configure Vault role...\n"
kubectl -n ${VAULT_NAMESPACE} exec ${VAULT_POD_NAME} -- vault write aws/roles/cartography \
    role_arns=arn:aws:iam::${HUB_ID}:role/${ROLE_ASSUME} \
    credential_type=assumed_role                         \
    default_sts_ttl=21600                                \
    max_sts_ttl=21600

#
# Deploy Cartography:
#   - Deploy the Cartography CronJob
#
printf "\n[+] Deploying Cartography on ${TARGET}...\n"
if [[ $TARGET == "baremetal" ]]
then
    plz run //components/cartography:cartography-baremetal_push
else
    plz run //components/cartography:cartography-minikube_push
fi
