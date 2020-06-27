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
