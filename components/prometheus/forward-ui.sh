#! /bin/bash

NAMESPACE="metrics"
GRAFANA_USER=$(kubectl -n ${NAMESPACE} get secrets prometheus-helm-grafana -o=jsonpath='{.data.admin-user}' | base64 --decode)
GRAFANA_PASSWORD=$(kubectl -n ${NAMESPACE} get secrets prometheus-helm-grafana -o=jsonpath='{.data.admin-password}' | base64 --decode)

#
# Prometheus
#
printf "[+] Forwarding Prometheus Service to http://127.0.0.1:9090\n"
kubectl -n ${NAMESPACE} port-forward svc/prometheus-helm-prometheus-prometheus 9090 &

#
# Grafana
#
printf "[+] Forwarding Grafana UI to http://127.0.0.1:9191\n"
printf "\t[*] Username: ${GRAFANA_USER}\n"
printf "\t[*] Password: ${GRAFANA_PASSWORD}\n"
kubectl -n ${NAMESPACE} port-forward svc/prometheus-helm-grafana 9191:80 &

#
# Alertmanager
#
printf "[+] Forwarding Alertmanager Service to http://127.0.0.1:9093\n"
kubectl -n ${NAMESPACE} port-forward svc/prometheus-helm-prometheus-alertmanager 9093 &
