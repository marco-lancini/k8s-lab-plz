#! /bin/bash

#
# Deploying Elastic Operator
#
printf "[>] Deploying Elastic Operator...\n"
plz run //components/elk:eck_push

status=$(kubectl -n elastic-system get po elastic-operator-0 -o json | jq '.status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for Elastic Operator to be ready...\n"
    sleep 5
    status=$(kubectl -n elastic-system get po elastic-operator-0 -o json | jq '.status.phase')
done

#
# Deploying Elasticsearch cluster
#
printf "[>] Deploying Elasticsearch cluster...\n"
plz run //components/elk:elasticsearch_push

status=$(kubectl -n elastic-system get pods --selector='elasticsearch.k8s.elastic.co/cluster-name=elasticsearch' -o json | jq '.items[].status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for Elasticsearch to be ready...\n"
    sleep 5
    status=$(kubectl -n elastic-system get pods --selector='elasticsearch.k8s.elastic.co/cluster-name=elasticsearch' -o json | jq '.items[].status.phase')
done

#
# Deploying Kibana instance
#
printf "[>] Deploying Kibana instance...\n"
plz run //components/elk:kibana_push

status=$(kubectl -n elastic-system get pod --selector='kibana.k8s.elastic.co/name=kibana' -o json | jq '.items[].status.phase')
while [ -z "$status" ] || [ $status != '"Running"' ]
do
    printf "\t[*] Waiting for Kibana to be ready...\n"
    sleep 5
    status=$(kubectl -n elastic-system get pod --selector='kibana.k8s.elastic.co/name=kibana' -o json | jq '.items[].status.phase')
done
