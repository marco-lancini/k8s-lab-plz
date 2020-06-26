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
