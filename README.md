<p align="center"><img src=".github/k8s_lab_plz_logo.png" width="60%"></p>

`k8s-lab-plz` is a modular Kubernetes lab which provides an easy and streamlined way (managed via [please.build](https://please.build/)) to deploy a test cluster with support for different components.

Each component can be deployed in a repeatable way with one single command.

Usage for supported components:

| Component                                                | Usage                           | Namespace                                        |
| -------------------------------------------------------- | ------------------------------- | ------------------------------------------------ |
| Baremetal Setup (Load Balancing, Volumes, etc.)          | [docs](components/baremetal/)   | `ingress-nginx`<br>`metallb-system`<br>`haproxy` |
| Vault                                                    | [docs](components/vault/)       | `vault`                                          |
| ELK (Elasticsearch, Kibana, Filebeats)                   | [docs](components/elk/)         | `elastic-system`                                 |
| Metrics (Prometheus, Grafana, Alertmanager)              | [docs](components/prometheus/)  | `metrics`                                        |
| Kafka (Kafka, Zookeeper, KafkaExporter, Entity Operator) | [docs](components/kafka/)       | `kafka`                                          |
| Cartography                                              | [docs](components/cartography/) | `cartography`                                    |
| Yopass                                                   | [docs](components/yopass/)      | `yopass`                                         |


## Prerequisites
* Minikube (see [official docs](https://kubernetes.io/docs/tasks/tools/install-minikube/) for your OS) or Baremetal Kubernetes (see [baremetal setup](components/baremetal/))
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
* [X] ~~Cartography~~
* [X] ~~Yopass~~
* [ ] Istio
* [ ] Gatekeeper
* [ ] Falco
* [ ] Starboard
* [ ] Audit logging
* [ ] Private Registry

Interested in another component to be added? Raise an issue!

For a more detailed view of what's coming up, please refer to the
[Kanban board](https://github.com/marco-lancini/k8s-lab/projects/1).
