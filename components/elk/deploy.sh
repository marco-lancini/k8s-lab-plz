#! /bin/bash

NAMESPACE="elastic-system"

wait_pod () {
status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for $1 to be ready...\n"
    sleep 5
    status=$(kubectl -n ${NAMESPACE} get pods --selector="${2}" -o json | jq '.items[].status.phase')
done
printf "\t[*] $1 is ready\n"
}

#
# Deploying Elastic Operator
#
printf "[+] Deploying Elastic Operator...\n"
plz run //components/elk:eck_push
wait_pod 'Elastic Operator' 'control-plane=elastic-operator'

#
# Deploying Elasticsearch cluster
#
printf "[+] Deploying Elasticsearch cluster...\n"
plz run //components/elk:elasticsearch_push
wait_pod 'Elasticsearch' 'elasticsearch.k8s.elastic.co/cluster-name=elasticsearch'

#
# Deploying Kibana instance
#
printf "[+] Deploying Kibana instance...\n"
plz run //components/elk:kibana_push
wait_pod 'Kibana' 'kibana.k8s.elastic.co/name=kibana'

#
# Deploying Filebeats
#
printf "[+] Deploying Filebeats...\n"
plz run //components/elk:filebeats_push
wait_pod 'Filebeats' 'k8s-app=filebeat'
