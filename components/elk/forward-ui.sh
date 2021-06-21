#! /bin/bash

NAMESPACE="elastic"

#
# Elasticsearch Endpoint
#
printf "[+] Forwarding Elasticsearch Service to http://127.0.0.1:9200\n"
printf "\t[*] From inside the Kubernetes cluster: curl -k 'http://elasticsearch:9200'\n"
printf "\t[*] From your local workstation: curl -k 'http://localhost:9200'\n"
kubectl -n ${NAMESPACE} port-forward svc/elasticsearch 9200 &

#
# Kibana UI
#
printf "[+] Forwarding Kibana UI to http://127.0.0.1:5601\n"
kubectl -n ${NAMESPACE} port-forward svc/kibana 5601 &
