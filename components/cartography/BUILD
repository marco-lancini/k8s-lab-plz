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

sh_binary(
    name = "deploy-elastic-ingestor",
    main = "setup/elastic-ingestor.sh",
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
    dockerfile = "deployment/cartography/docker/Dockerfile",
    srcs = glob(["deployment/cartography/docker/**/*"]),
    image = "cartography",
    version = "1.5",
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

# ==============================================================================
# Deploy Elasticsearch Integration
# ==============================================================================
# Queries file
remote_file(
    name = "cartography_queries",
    url = "https://raw.githubusercontent.com/marco-lancini/cartography-queries/master/queries/queries.json"
)

# Python Scripts
python_library(
    name = "neo4j_connector",
    srcs = ["consumers/elasticsearch/py/neo4j_connector.py"],
    deps = [
        ":cartography_queries",
        "//third_party/python:neo4j",
        "//third_party/python:neobolt",
        "//third_party/python:neotime",
    ],
)

python_library(
    name = "elastic_connector",
    srcs = ["consumers/elasticsearch/py/elastic_connector.py"],
)

python_library(
    name = "elastic_ingestor",
    srcs = ["consumers/elasticsearch/py/elastic_ingestor.py"],
    deps = [
        ":neo4j_connector",
    ],
)

# Docker image
filegroup(
    name = "docker-requirements",
    srcs = [
        "consumers/elasticsearch/deployment/docker/requirements.txt",
    ],
)

docker_image(
    name = "cartography_ingestor_image",
    srcs = [
        ":docker-requirements",
        ":cartography_queries",
        ":neo4j_connector",
        ":elastic_connector",
        ":elastic_ingestor",
    ],
    dockerfile = "consumers/elasticsearch/deployment/docker/Dockerfile",
    image = "cartography_elastic_ingestor",
    version = "0.1.4",
    repo = "marcolancini",
    visibility = ["//components/cartography/..."],
)

# Kubernetes deployment
kustomize_prep(
    name = "kustomize-elastic-ingestor",
    srcs = glob(["consumers/elasticsearch/deployment/**/*.*"]),
    containers = [
        ":cartography_ingestor_image",
    ],
)

kustomize(
    name = "elastic-ingestor-baremetal",
    namespace = "cartography",
    kustomize_path = "consumers/elasticsearch/deployment",
    overlay = "baremetal",
    srcs = [":kustomize-elastic-ingestor"],
)


kustomize(
    name = "elastic-ingestor-minikube",
    namespace = "cartography",
    kustomize_path = "consumers/elasticsearch/deployment",
    overlay = "minikube",
    srcs = [":kustomize-elastic-ingestor"],
)
