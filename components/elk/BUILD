subinclude("//build_defs:docker")
subinclude("//build_defs:helm_chart")
subinclude("//build_defs:k8s")

sh_binary(
    name = "deploy",
    main = "deploy.sh",
)

sh_binary(
    name = "ui",
    main = "forward-ui.sh",
)

# ==============================================================================
# ECK
# ==============================================================================
k8s_config(
    name = "eck",
    srcs = ["//third_party:eck-downloader"],
    visibility = ["//components/elk/..."]
)

k8s_config(
    name = "elasticsearch",
    srcs = ["k8s/elasticsearch.yaml"],
)

k8s_config(
    name = "kibana",
    srcs = ["k8s/kibana.yaml"],
)
