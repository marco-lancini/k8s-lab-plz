#! /bin/bash

# Activating Fedora module repositories
sed -i -z s/enabled=0/enabled=1/ /etc/yum.repos.d/fedora-modular.repo
sed -i -z s/enabled=0/enabled=1/ /etc/yum.repos.d/fedora-updates-modular.repo
sed -i -z s/enabled=0/enabled=1/ /etc/yum.repos.d/fedora-updates-testing-modular.repo

# Setting up the CRI-O module
mkdir /etc/dnf/modules.d
cat <<EOF > /etc/dnf/modules.d/cri-o.module
[cri-o]
name=cri-o
stream=1.17
profiles=
state=enabled
EOF

# Installing CRI-O
rpm-ostree install cri-o
systemctl reboot
