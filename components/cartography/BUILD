subinclude("//build_defs:docker_repository")
subinclude("//build_defs:docker")
subinclude("//build_defs:helm_chart")
subinclude("//build_defs:k8s")

sh_binary(
    name = "deploy",
    main = "deploy.sh",
)

# sh_binary(
#     name = "ui",
#     main = "forward-ui.sh",
# )

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
k8s_config(
    name = "neo4j-pv-baremetal",
    srcs = ["deployment/neo4j/neo4j-pv-baremetal.yaml"],
)

k8s_config(
    name = "neo4j",
    srcs = [
        # "deployment/neo4j/neo4j-certificate.yaml",
        "deployment/neo4j/neo4j-ingress.yaml",
        "deployment/neo4j/neo4j-service.yaml",
        "deployment/neo4j/neo4j-statefulset.yaml",
    ],
    containers = [
        "//third_party/docker:neo4j",
    ],
)
