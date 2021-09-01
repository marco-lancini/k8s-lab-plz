# Cartography Setup

[Cartography](https://github.com/lyft/cartography) is a Python tool that consolidates infrastructure assets and the relationships between them in an intuitive graph view powered by a Neo4j database.

## Prerequisites

| Component                  | Instructions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Vault                      | ⚠️ This module depends on a Vault installation. Please refer to [Vault Setup](../vault/) for more information.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Elasticsearch (optional)   | ⚠️ This module depends on an ELK installation. Please refer to [ELK Setup](../elk/) for more information.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Cloud Provider Credentials | <ul><li>You will need to generate access tokens for Cartography to use.</li><li>For example, for AWS:<ul><li>You can use the [aws-security-reviewer](https://github.com/marco-lancini/utils/tree/main/terraform/aws-security-reviewer) Terraform module to automate the setup of roles and users needed to perform a security audit of AWS accounts in an Hub and Spoke model.</li><li>Then, generate access keys for the IAM user and keep them ready to use.</li></ul></li></ul> |


---


## Deploy Cartography and Neo4j

![](../../.github/components/cartography_setup.png)

* Deploy Cartography and Neo4j:
  ```bash
  ❯ plz run //components/cartography:deploy [minikube|baremetal]
  ```
  * This command will:
    * Setup namespace: creates a `cartography` namespace, and a Vault Agent service account
    * Setup and Deploy Neo4j:
      * Generates a random password for Neo4j and stores it into Vault
      * Generates TLS Certificates
      * Created a StorageClass, PersistentVolume, and Ingress (baremetal only)
      * Deploys the Neo4j StatefulSet and Service
    * Setup and Deploy Cartography:
      * Creates a custom Docker image for Cartography
      * Requests user to provide access key, secret key, and Account ID of the Hub
      * Setup Vault:
        * Enables the AWS secrets engine
        * Persists the credentials that Vault will use to communicate with AWS
        * Configures a Vault role that maps to a set of permissions in AWS
      * Deploys the Cartography CronJob, scheduled to run every day at 7am

* Verify pods are healthy:
  ```bash
  ❯ kubectl -n cartography get po
  NAME                  READY   STATUS    RESTARTS   AGE
  neo4j-statefulset-0   2/2     Running   0          5h56m
  ```

* Manually trigger the execution of a Cartography Job:
  ```bash
  ❯ kubectl -n cartography create job --from=cronjob/cartography-run cartography-run
  ```

* 📝 **NOTE FOR BAREMETAL**: before deploying, make sure to prepare
the data folder on the host (and to remove the same folder to reset the installation):
  ```bash
  ❯ sudo mkdir -p /etc/plz-k8s-lab/cartography/neo4j/
  ❯ sudo chmod -R a+rw /etc/plz-k8s-lab/cartography/
  ```


---


## Access the Neo4J  UI

### Via Port-Forward
* Forward the Vault UI to http://127.0.0.1:7474
  ```bash
  ❯ plz run //components/vault:ui
  ```

### Via Ingress on Baremetal
* Verify the Ingresses have been deployed:
  ```bash
  ❯ kubectl -n cartography get ingress
  NAME                 CLASS    HOSTS                        ADDRESS   PORTS     AGE
  neo4j-ingress        <none>   neo4j.192.168.1.151.nip.io             80, 443   6h7m
  neo4j-ingress-bolt   <none>   bolt.192.168.1.151.nip.io              80, 443   6h7m
  ```

* 📝 **NOTE**: before deploying, make sure to replace the host IP address in:
  * `//components/cartography/deployment/neo4j/overlays/baremetal/neo4j-ingress.yaml`
  * `//components/cartography/setup/neo4j.sh`
  * This assumes you followed the setup described at "[Kubernetes Lab on Baremetal](https://www.marcolancini.it/2021/blog-kubernetes-lab-baremetal/)".
* To access the Neo4j web UI:
  * Browse to: https://neo4j.192.168.1.151.nip.io/browser/
  * Connect URL: `bolt://bolt.192.168.1.151.nip.io:443`
  * Username: `neo4j`
  * Password: stored in Vault at `secret/cartography/neo4j-password`

![](../../.github/components/neo4j_ui.png)


---


## Elasticsearch Ingestor

The Elasticsearch Ingestor is a CronJob which executes
a set of [custom queries](https://github.com/marco-lancini/cartography-queries/tree/main/queries)
against the Neo4j database, and pushes the results to Elasticsearch.

* Deploy the CronJob:
  ```bash
  ❯ plz run //components/cartography:deploy-elastic-ingestor [minikube|baremetal]
  ```
* 📝 **NOTE**: before deploying, make sure to have an Elasticsearch cluster deployed. Refer to [ELK Setup](../elk/) for more information.
* You can then [import pre-populated visualizations and dashboards for Kibana](https://github.com/marco-lancini/cartography-queries/tree/main/consumers/elasticsearch) I made available


---


## References
* **[CODE]** [Cartography's source code](https://github.com/lyft/cartography)
* **[CODE]** [cartography-queries](https://github.com/marco-lancini/cartography-queries)
* **[CODE]** [Terraform AWS Security Reviewer](https://github.com/marco-lancini/utils/tree/main/terraform/aws-security-reviewer)
* **[BLOG]** [Mapping Moving Clouds: How to stay on top of your ephemeral environments with Cartography](https://www.marcolancini.it/2020/blog-mapping-moving-clouds-with-cartography/)
* **[BLOG]** [Tracking Moving Clouds: How to continuously track cloud assets with Cartography](https://www.marcolancini.it/2020/blog-tracking-moving-clouds-with-cartography/)
* **[BLOG]** [Automating Cartography Deployments on Kubernetes](https://www.marcolancini.it/2021/blog-cartography-on-kubernetes/)
* **[BLOG]** [Cross Account Auditing in AWS and GCP](https://www.marcolancini.it/2019/blog-cross-account-auditing/)
* **[BLOG]** [Kubernetes Lab on Baremetal](https://www.marcolancini.it/2021/blog-kubernetes-lab-baremetal/)
* **[TALK]** [Cartography: using graphs to improve and scale security decision-making](https://speakerdeck.com/marcolancini/cartography-using-graphs-to-improve-and-scale-security-decision-making)
