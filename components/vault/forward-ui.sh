#! /bin/bash

printf "[>] Forwarding Vault UI to 127.0.0.1:8200\n"
kubectl -n vault port-forward svc/vault-helm-ui 8200 &
