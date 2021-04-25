#! /bin/bash

# Create config
cat <<EOF > clusterconfig.yml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: v1.20.5
controllerManager:
  extraArgs:
    flex-volume-plugin-dir: "/etc/kubernetes/kubelet-plugins/volume/exec"
networking:
  podSubnet: 10.244.0.0/16
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
nodeRegistration:
  criSocket: /var/run/crio/crio.sock
EOF

# Install
kubeadm init --config clusterconfig.yml
kubectl taint nodes --all node-role.kubernetes.io/master-

# Setup Flannel
sudo sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
