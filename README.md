# K8S-LAB

Modular Kubernetes Lab which provides an easy and streamlined way (managed via `plz`) to deploy a test cluster with support for different components.

Supported components:

1. [Vault](docs/vault.md)
2. ...


## Prerequisites
* Minikube (see [official docs](https://kubernetes.io/docs/tasks/tools/install-minikube/) for your OS)
* Docker (see [official docs](https://docs.docker.com/get-docker/) for your OS)
* Plz (see [official docs](https://please.build/quickstart.html) for your OS)
* Helm (see [official docs](https://helm.sh/docs/intro/install/) for your OS)

Ensure minikube is up and running:
```bash
❯ minikube start --memory 4092
```
