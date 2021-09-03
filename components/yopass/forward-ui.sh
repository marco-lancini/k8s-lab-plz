#! /bin/bash

NAMESPACE="yopass"

#
# Yopass UI
#
printf "[+] Forwarding Yopass UI to http://127.0.0.1:1337\n"
kubectl -n ${NAMESPACE} port-forward svc/yopass-service 1337 &
