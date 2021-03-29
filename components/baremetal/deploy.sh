#! /bin/bash

wait_pod () {
status=$(kubectl -n ${3} get pods --selector="${2}" -o json | jq '.items[].status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for ${1} to be ready...\n"
    sleep 5
    status=$(kubectl -n ${3} get pods --selector="${2}" -o json | jq '.items[].status.phase')
done
printf "\t[*] ${1} is ready\n"
}

# Deploy NGINX
#   - Create `ingress-nginx` namespace
#   - Fetch and deploy the NGINX manifest
printf "\n[+] Deploying NGINX Ingress Controller...\n"
plz run //components/baremetal:nginx-operator_push
wait_pod 'NGINX Operator' 'app.kubernetes.io/name=ingress-nginx,app.kubernetes.io/component=controller' 'ingress-nginx'

# Deploy MetalLB
#   - Enable strict ARP mode
#   - Create `metallb-system` namespace
#   - Fetch and deploy the MetalLB manifest
#   - Create `memberlist` secret
printf "\n[+] Deploying MetalLB...\n"
kubectl get configmap kube-proxy -n kube-system -o yaml | \
              sed -e "s/strictARP: false/strictARP: true/" | \
              kubectl apply -f - -n kube-system
plz run //components/baremetal:metallb-namespace_push
plz run //components/baremetal:metallb-deployment_push
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
wait_pod 'MetalLB Controller' 'app=metallb,component=controller' 'metallb-system'
wait_pod 'MetalLB DaemonSet' 'app=metallb,component=speaker' 'metallb-system'

# Deploy MetalLB ConfigMap
printf "\n[+] Deploying MetalLB ConfigMap...\n"
plz run //components/baremetal:metallb-config_push

# Deploy HAProxy
#   - Create `haproxy` namespace
#   - Fetch and deploy the HAProxy Helm chart
printf "\n[+] Deploying HAProxy...\n"
plz run //components/baremetal:haproxy-namespace_push
plz run //components/baremetal:haproxy-helm_push
