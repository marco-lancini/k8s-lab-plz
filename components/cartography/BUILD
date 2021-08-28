subinclude("//build_defs:docker_repository")
subinclude("//build_defs:docker")
subinclude("//build_defs:helm_chart")
subinclude("//build_defs:k8s")
subinclude("//build_defs:kustomize")

sh_binary(
    name = "deploy",
    main = "deploy.sh",
)

sh_binary(
    name = "ui",
    main = "forward-ui.sh",
)



k8s_config(
    name = "cartography-namespace",
    srcs = ["deployment/cartography-namespace.yaml"],
)

# ==============================================================================
# Deploy Neo4J
# ==============================================================================
sh_binary(
    name = "deploy-neo4j",
    main = "setup/neo4j.sh",
)

kustomize_prep(
    name = "kustomize-neo4j",
    srcs = glob(["deployment/neo4j/**/*.yaml"]),
    containers = [
        "//third_party/docker:neo4j",
    ],
)

kustomize(
    name = "neo4j-baremetal",
    namespace = "cartography",
    kustomize_path = "deployment/neo4j",
    overlay = "baremetal",
    srcs = [":kustomize-neo4j"],
)

kustomize(
    name = "neo4j-minikube",
    namespace = "cartography",
    kustomize_path = "deployment/neo4j",
    overlay = "minikube",
    srcs = [":kustomize-neo4j"],
)

# ==============================================================================
# Deploy Cartography
# ==============================================================================
sh_binary(
    name = "deploy-cartography",
    main = "setup/cartography.sh",
)

docker_image(
    name = "cartography_docker",
    dockerfile = "deployment/cartography/Dockerfile-cartography",
    image = "cartography",
    version = "1.4",
    repo = "marcolancini",
    visibility = ["//components/cartography/..."],
)

kustomize_prep(
    name = "kustomize-cartography",
    srcs = glob(["deployment/cartography/**/*.yaml"]),
    containers = [
        ":cartography_docker",
    ],
)

kustomize(
    name = "cartography-baremetal",
    namespace = "cartography",
    kustomize_path = "deployment/cartography",
    overlay = "baremetal",
    srcs = [":kustomize-cartography"],
)

kustomize(
    name = "cartography-minikube",
    namespace = "cartography",
    kustomize_path = "deployment/cartography",
    overlay = "minikube",
    srcs = [":kustomize-cartography"],
)
