# K8S-LAB-PLZ

Modular Kubernetes Lab which provides an easy and streamlined way (managed via [please.build](https://please.build/)) to deploy a test cluster with support for different components.

Each component can be deployed in a repeatable way with one single command.

Usage for supported components:

| Component                                                | Usage                                              | Namespace                                        |
| -------------------------------------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| Baremetal Setup (Load Balancing, Volumes, etc.)          | [docs/baremetal_setup.md](docs/baremetal_setup.md) | `ingress-nginx`<br>`metallb-system`<br>`haproxy` |
| Vault                                                    | [docs/vault.md](docs/vault.md)                     | `vault`                                          |
| ELK (Elasticsearch, Kibana, Filebeats)                   | [docs/elk.md](docs/elk.md)                         | `elastic-system`                                 |
| Metrics (Prometheus, Grafana, Alertmanager)              | [docs/prometheus.md](docs/prometheus.md)           | `metrics`                                        |
| Kafka (Kafka, Zookeeper, KafkaExporter, Entity Operator) | [docs/kafka.md](docs/kafka.md)                     | `kafka`                                          |


## Prerequisites
* Minikube (see [official docs](https://kubernetes.io/docs/tasks/tools/install-minikube/) for your OS) or Baremetal Kubernetes (see [baremetal setup](docs/baremetal_setup.md))
  * If using minikube, ensure it is up and running:
  ```bash
  ❯ minikube start --cpus 4 --memory 6098
  ```
* Docker (see [official docs](https://docs.docker.com/get-docker/) for your OS)
* Plz (see [official docs](https://please.build/quickstart.html) for your OS)
* Helm 3 (see [official docs](https://helm.sh/docs/intro/install/) for your OS)


## Roadmap
* [X] ~~Vault~~
* [X] ~~ELK (Elasticsearch, Kibana, Filebeats)~~
* [X] ~~Metrics (Prometheus, Grafana, Alertmanager)~~
* [X] ~~Kafka (Kafka, Zookeeper, KafkaExporter, Entity Operator)~~
* [X] ~~Baremetal Setup (Load Balancing, Volumes, etc.)~~
* [ ] Istio
* [ ] Gatekeeper
* [ ] Falco
* [ ] Starboard
* [ ] Audit logging
* [ ] Private Registry

Interested in another component to be added? Raise an issue!

For a more detailed view of what's coming up, please refer to the
[Kanban board](https://github.com/marco-lancini/k8s-lab/projects/1).
