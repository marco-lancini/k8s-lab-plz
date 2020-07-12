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
KAFKA_OPERATOR_VERSION="0.18.0"
KAFKA_OPERATOR_HASH="a5dfcaa3f331133f4cc43804f35cc9460a60e04a"

remote_file(
    name = "kafka-operator",
    out = "kafka-operator.yaml",
    url = "https://github.com/strimzi/strimzi-kafka-operator/releases/download/%s/strimzi-cluster-operator-%s.yaml" % (KAFKA_OPERATOR_VERSION, KAFKA_OPERATOR_VERSION),
    hashes = [KAFKA_OPERATOR_HASH],
    visibility = ["//components/kafka/..."],
    extract = False
)
