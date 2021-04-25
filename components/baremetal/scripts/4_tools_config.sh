#! /bin/bash

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

systemctl enable --now cri-o && systemctl enable --now kubelet
echo "KUBELET_EXTRA_ARGS=--cgroup-driver=systemd" | tee /etc/sysconfig/kubelet
