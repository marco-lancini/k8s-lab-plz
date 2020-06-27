#! /bin/bash

# Deploy Vault:
#   - Create `vault` namespace
#   - Fetch and deploy the Vault Helm chart
printf "\n[+] Deploying Vault...\n"
plz run //components/vault:vault-namespace_push
plz run //components/vault:vault-helm_push

# Initialize Vault and enable Kubernetes backend (will print root token)
printf "\n[+] Initializing Vault...\n"
plz run //components/vault:vault-init

# Setup sidecar Agent (create role/policy)
printf "\n[+] Setting up sidecar Agent...\n"
plz run //components/vault:agent-init
plz run //components/vault:agent-service-account_push
