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
# Deploy Neo4J
# ==============================================================================
sh_binary(
    name = "deploy-neo4j",
    main = "setup/neo4j.sh",
)

k8s_config(
    name = "neo4j",
    srcs = [
        # "deployment/neo4j/neo4j-certificate.yaml",
        "deployment/neo4j/neo4j-service.yaml",
        "deployment/neo4j/neo4j-statefulset.yaml",
    ],
    containers = [
        "//third_party/docker:neo4j",
    ],
)

# ==============================================================================
# Deploy Cartography
# ==============================================================================
sh_binary(
    name = "deploy-cartography",
    main = "setup/cartography.sh",
)

k8s_config(
    name = "cartography",
    srcs = [
        "deployment/cartography/aws-accounts-configmap.yaml",
        "deployment/cartography/cartography-job.yaml",
    ],
    containers = [
        ":cartography_docker",
    ],
)

docker_image(
    name = "cartography_docker",
    dockerfile = "deployment/cartography/Dockerfile-cartography",
    image = "cartography",
    version = "1.4",
    repo = "marcolancini",
    visibility = ["//components/cartography/..."],
)

# ==============================================================================
# BAREMETAL
# ==============================================================================
k8s_config(
    name = "neo4j-baremetal",
    srcs = [
        "baremetal/neo4j-pv.yaml",
        "baremetal/neo4j-ingress.yaml"
    ],
)
