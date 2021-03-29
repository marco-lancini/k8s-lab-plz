# ==============================================================================
# VAULT
# ==============================================================================
VAULT_VERSION="0.6.0"
VAULT_HASH="25681ae11e8684f53eb69830867123608c75c845058c323c9e32bfcd16f3c180"

remote_file(
    name = "helm-vault-tar",
    out = "vault",
    url = "https://github.com/hashicorp/vault-helm/archive/v%s.tar.gz" % VAULT_VERSION,
    hashes = [VAULT_HASH],
    visibility = ["//components/vault/..."],
    extract = True
)

# ==============================================================================
# ECK
# ==============================================================================
ECK_VERSION="1.1.2"
ECK_HASH="c66243a442d0c7e71d077d5578905caebbd6ecfc"

remote_file(
    name = "eck-downloader",
    out = "eck.yaml",
    url = "https://download.elastic.co/downloads/eck/%s/all-in-one.yaml" % ECK_VERSION,
    hashes = [ECK_HASH],
    visibility = ["//components/elk/..."]
)

# ==============================================================================
# PROMETHEUS
# ==============================================================================
PROMETHEUS_VERSION="8.15.6"
PROMETHEUS_HASH="3938f67923067b23c2859b6a7e07b8edb96a13b8eaa0806e3f460ed4d59ff4d0"

remote_file(
    name = "helm-prometheus-tar",
    out = "prometheus",
    url = "https://kubernetes-charts.storage.googleapis.com/prometheus-operator-%s.tgz" % PROMETHEUS_VERSION,
    hashes = [PROMETHEUS_HASH],
    visibility = ["//components/prometheus/..."],
    extract = True
)

# ==============================================================================
# KAFKA
# ==============================================================================
KAFKA_OPERATOR_VERSION="0.20.0"
KAFKA_OPERATOR_HASH="c065c9b075b1bdfb59d9d2444e3cda86c14942d2a3da86e2e7b377b64cfa3d06"

remote_file(
    name = "kafka-operator",
    out = "kafka-operator.yaml",
    url = "https://github.com/strimzi/strimzi-kafka-operator/releases/download/%s/strimzi-cluster-operator-%s.yaml" % (KAFKA_OPERATOR_VERSION, KAFKA_OPERATOR_VERSION),
    hashes = [KAFKA_OPERATOR_HASH],
    visibility = ["//components/kafka/..."],
    extract = False
)

# ==============================================================================
# NGINX
# ==============================================================================
NGINX_OPERATOR_VERSION="0.44.0"
NGINX_OPERATOR_HASH="d5071e1d983c130641bf6261cf4ef61f58bd422d80a888946db27c6660190bc0"

remote_file(
    name = "nginx-operator",
    out = "nginx-operator.yaml",
    url = "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v%s/deploy/static/provider/baremetal/deploy.yaml" % NGINX_OPERATOR_VERSION,
    hashes = [NGINX_OPERATOR_HASH],
    visibility = ["//components/..."],
    extract = False
)

# ==============================================================================
# METALLB
# ==============================================================================
METALLB_NAMESPACE_VERSION="0.9.5"
METALLB_NAMESPACE_HASH="51a1c68cd8f92e4653075ea978642689a7786099000f9017a616567bab76114f"

remote_file(
    name = "metallb-namespace",
    out = "metallb-namespace.yaml",
    url = "https://raw.githubusercontent.com/metallb/metallb/v%s/manifests/namespace.yaml" % METALLB_NAMESPACE_VERSION,
    hashes = [METALLB_NAMESPACE_HASH],
    visibility = ["//components/baremetal/..."],
    extract = False
)

METALLB_DEPLOYMENT_VERSION="0.9.5"
METALLB_DEPLOYMENT_HASH="15c30085c20bbc36c2ce81881180b75e503a5d95bacce45733e3b5131a7d866b"

remote_file(
    name = "metallb-deployment",
    out = "metallb-deployment.yaml",
    url = "https://raw.githubusercontent.com/metallb/metallb/v%s/manifests/metallb.yaml" % METALLB_DEPLOYMENT_VERSION,
    hashes = [METALLB_DEPLOYMENT_HASH],
    visibility = ["//components/baremetal/..."],
    extract = False
)

# ==============================================================================
# HAPROXY
# ==============================================================================
HAPROXY_VERSION="0.12.2"
HAPROXY_HASH="819cb1df52060f35caa8cb81ace715bfe90dca2fed34344e00a670d25b0df941"

remote_file(
    name = "helm-haproxy-tar",
    out = "haproxy",
    url = "https://github.com/haproxy-ingress/charts/releases/download/%s/haproxy-ingress-%s.tgz" % (HAPROXY_VERSION, HAPROXY_VERSION),
    hashes = [HAPROXY_HASH],
    visibility = ["//components/baremetal/..."],
    extract = True
)
