# Baremetal Setup

Instructions for deploying a Kubernetes cluster on Baremetal,
as described in the
"[Kubernetes Lab on Baremetal](https://www.marcolancini.it/2021/blog-kubernetes-lab-baremetal/)"
blog post.


## Kubernetes Installation (manual)

1. **Install CoreOS:** manual process, refer to the blog post.
2. **Install Kubernetes:** copy the set of scripts contained in the [scripts](scripts/) folder, and run them directly on Fedora CoreOS:

```bash
[root@cluster core]$ ./1_crio_install.sh
[root@cluster core]$ ./2_crio_config.sh
[root@cluster core]$ ./3_tools_install.sh
[root@cluster core]$ ./4_tools_config.sh
[root@cluster core]$ ./5_cluster_install.sh
```

## Ingress Controllers and LoadBalancing on Baremetal

```bash
❯ plz run //components/baremetal:deploy
```
* Creates the `ingress-nginx`, `metallb-system`, and `haproxy` namespaces
* Fetches and deploys the NGINX Ingress Controller in the `ingress-nginx` namespace
* Enables strict ARP mode, and deploys MetalLB in the `metallb-system` namespace
* Deploys the MetalLB ConfigMap in the `metallb-system` namespace
* Fetches and deploys the HAProxy Helm chart in the `haproxy` namespace

📝 **Note:** remember to edit the address pool in `components/baremetal/k8s/metallb-config.yaml`
to suit your needs.

Verify pods are healthy:
```bash
❯ kgpoall
+ kubectl get pods --all-namespaces
NAMESPACE        NAME                                            READY   STATUS      RESTARTS   AGE
haproxy          haproxy-helm-haproxy-ingress-5546d459cd-v9vz7   1/1     Running     0          9m1s
ingress-nginx    ingress-nginx-admission-create-95njm            0/1     Completed   0          9m35s
ingress-nginx    ingress-nginx-admission-patch-w4ljg             0/1     Completed   0          9m35s
ingress-nginx    ingress-nginx-controller-67897c9494-dgxxw       1/1     Running     0          9m35s
kube-system      coredns-74ff55c5b-2qdkf                         1/1     Running     0          9d
kube-system      coredns-74ff55c5b-5blfn                         1/1     Running     0          9d
kube-system      etcd-cluster                                    1/1     Running     0          9d
kube-system      kube-apiserver-cluster                          1/1     Running     0          9d
kube-system      kube-controller-manager-cluster                 1/1     Running     0          9d
kube-system      kube-flannel-ds-22ltx                           1/1     Running     0          9d
kube-system      kube-proxy-2lbvn                                1/1     Running     0          9d
kube-system      kube-scheduler-cluster                          1/1     Running     0          9d
metallb-system   controller-65db86ddc6-p8pkz                     1/1     Running     0          9m28s
metallb-system   speaker-kfkm6                                   1/1     Running     0          9m29s
```

## Tests

```bash
❯ plz run //components/baremetal:sample-ingress_push
```
* Deploys a test Deployment, Service, and Ingress to leverage the new setup.
* 📝 **Note:** remember to replace the host IP with the one of your host in `components/baremetal/k8s/sample-ingress.yaml`.

```bash
❯ plz run //components/baremetal:sample-pvc_push
```
* Deploys a `hostPath` PV, PVC, and a Pod which leverages them.
