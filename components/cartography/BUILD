subinclude("//build_defs:docker_repository")
subinclude("//build_defs:docker")
subinclude("//build_defs:helm_chart")
subinclude("//build_defs:k8s")

sh_binary(
    name = "deploy",
    main = "deploy.sh",
)

# ==============================================================================
# Namespace Setup
# ==============================================================================
k8s_config(
    name = "cartography-namespace",
    srcs = ["deployment/cartography-namespace.yaml"],
)

k8s_config(
    name = "vault-agent-service-account",
    srcs = ["deployment/vault-agent-sa.yaml"],
)

# ==============================================================================
# BAREMETAL
# ==============================================================================
k8s_config(
    name = "neo4j-baremetal-pv",
    srcs = ["baremetal/neo4j-pv.yaml"],
)
