# Cartography Setup

⚠️ This module depends on a Vault installation.
Please refer to [Vault Setup](vault.md) for more information.


## Deploy Cartography and Neo4j
```bash
❯ plz run //components/cartography:deploy [minikube|baremetal]
```
* Setup namespace: creates a `cartography` namespace, and a Vault Agent service account
* Setup and Deploy Neo4j
* Setup and Deploy Cartography


* Generates a random password for Neo4j and stores it into Vault
