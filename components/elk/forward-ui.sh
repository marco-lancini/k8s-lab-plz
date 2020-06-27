#! /bin/bash

ELASTIC_USER="elastic"
ELASTIC_PASSWORD=$(kubectl -n elastic-system get secrets elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)

#
# Elasticsearch Endpoint
#
printf "[+] Forwarding Elasticsearch Service to http://127.0.0.1:9200\n"
printf "\t[*] From inside the Kubernetes cluster: curl -u '${ELASTIC_USER}:${ELASTIC_PASSWORD}' -k 'http://elasticsearch-es-http:9200'\n"
printf "\t[*] From your local workstation: curl -u '${ELASTIC_USER}:${ELASTIC_PASSWORD}' -k 'http://localhost:9200'\n"
kubectl -n elastic-system port-forward svc/elasticsearch-es-http 9200 &

#
# Kibana UI
#
printf "[+] Forwarding Kibana UI to http://127.0.0.1:5601\n"
printf "\t[*] Username: ${ELASTIC_USER}\n"
printf "\t[*] Password: ${ELASTIC_PASSWORD}\n"
kubectl -n elastic-system port-forward svc/kibana-kb-http 5601 &
