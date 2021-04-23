# Cartography Setup

[Cartography](https://github.com/lyft/cartography) is a Python tool that consolidates infrastructure assets and the relationships between them in an intuitive graph view powered by a Neo4j database.

⚠️ This module depends on a Vault installation.
Please refer to [Vault Setup](vault.md) for more information.


## Deploy Cartography and Neo4j
```bash
❯ plz run //components/cartography:deploy [minikube|baremetal]
```
* Setup namespace: creates a `cartography` namespace, and a Vault Agent service account
* Setup and Deploy Neo4j:
  * Generates a random password for Neo4j and stores it into Vault
  * Generates TLS Certificates and Ingress (baremetal only)
  * Created a StorageClass and PersistentVolume (baremetal only)
  * Deploys the Neo4j StatefulSet and Service


* Generates a random password for Neo4j and stores it into Vault
