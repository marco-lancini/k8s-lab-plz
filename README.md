# K8S-LAB

Modular Kubernetes Lab which provides an easy and streamlined way (managed via [please.build](https://please.build/)) to deploy a test cluster with support for different components.

Each component can be deployed in a repeatable way with one single command.

Usage for supported components:

1. [Vault](docs/vault.md)
2. [ELK](docs/elk.md)
3. ...


## Prerequisites
* Minikube (see [official docs](https://kubernetes.io/docs/tasks/tools/install-minikube/) for your OS)
* Docker (see [official docs](https://docs.docker.com/get-docker/) for your OS)
* Plz (see [official docs](https://please.build/quickstart.html) for your OS)
* Helm (see [official docs](https://helm.sh/docs/intro/install/) for your OS)

Ensure minikube is up and running:
```bash
❯ minikube start --cpus 4 --memory 6098
```


## Roadmap
* [X] Vault
* [X] ELK
* [ ] Prometheus & Grafana
* [ ] Audit logging
* [ ] Kafka
* [ ] Istio
* [ ] Private Registry
* [ ] Gatekeeper
* [ ] Starboard

Interested in another component to be added? Raise an issue!