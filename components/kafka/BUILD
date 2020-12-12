subinclude("//build_defs:docker")
subinclude("//build_defs:helm_chart")
subinclude("//build_defs:k8s")
subinclude("//build_defs:k8s_namespaced")

sh_binary(
    name = "deploy",
    main = "deploy.sh",
)

# ==============================================================================
# Deploy
# ==============================================================================
k8s_config(
    name = "kafka-namespace",
    srcs = ["k8s/kafka-namespace.yaml"],
)

genrule(
    # Needed to replace the placeholder namespace with ours
    name = "pull-operator",
    srcs = ["//third_party:kafka-operator"],
    outs = ["kafka-operator.yaml"],
    cmd = "sed 's/namespace: .*/namespace: kafka/' $SRCS > $OUT",
)

k8s_config_namespaced(
    name = "kafka-operator",
    srcs = [":pull-operator"],
    namespace = "kafka",
    visibility = ["//components/kafka/..."]
)

k8s_config(
    name = "kafka-cluster",
    srcs = ["k8s/kafka-cluster.yaml"],
    visibility = ["//components/kafka/..."]
)

# ==============================================================================
# Interact
# ==============================================================================
sh_binary(
    name = "list-topics",
    main = "scripts/list-topics.sh",
)

sh_binary(
    name = "consume-topic",
    main = "scripts/consume-topic.sh",
)

sh_binary(
    name = "produce-topic",
    main = "scripts/produce-topic.sh",
)
