#! /bin/bash

NAMESPACE="kafka"

printf "[+] Applying Strimzi installation file \n"


kubectl apply -f 'https://strimzi.io/install/latest?namespace=kafka' -n ${NAMESPACE}


