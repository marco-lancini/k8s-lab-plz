#! /bin/bash

NAMESPACE="yopass"
# SELECTOR="control-plane=elastic-operator"
TARGET=$1
if [[ $# -lt 1 ]] ; then
    TARGET="minikube"
fi

# Create `yopass` namespace
printf "\n[+] Creating ${NAMESPACE} namespace...\n"
plz run //components/yopass:yopass-namespace_push

# Deploying Yopass:
printf "\n[+] Deploying Yopass on ${TARGET}...\n"
if [[ $TARGET == "baremetal" ]]
then
    plz run //components/yopass:yopass-baremetal_push
else
    plz run //components/yopass:yopass-minikube_push
fi
