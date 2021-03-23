# Baremetal Setup

Instructions for deploying a Kubernetes cluster on Baremetal,
as described in:
[Kubernetes Lab on Baremetal](https://www.marcolancini.it/2021/blog-kubernetes-lab-baremetal/).


## Setup

1. **Install CoreOS:** manual process, refer to the blog post.
2. **Install Kubernetes:** copy the set of scripts contained in the [baremetal_setup](baremetal_setup/) folder, and run them directly on Fedora CoreOS:

```bash
[root@cluster core]$ ./1_crio_install.sh
[root@cluster core]$ ./2_crio_config.sh
[root@cluster core]$ ./3_tools_install.sh
[root@cluster core]$ ./4_tools_config.sh
[root@cluster core]$ ./5_cluster_install.sh
```
