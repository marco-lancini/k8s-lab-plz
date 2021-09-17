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
# Deploy via Helm
# ==============================================================================
helm_chart(
    name = "prometheus-helm",
    src = "//third_party:helm-prometheus-tar",
    install_path = "prometheus-operator",
    namespace = "observability",
    visibility = ["//components/prometheus/..."],
    deps = [
        ":observability-namespace",
    ]
)

k8s_config(
    name = "observability-namespace",
    srcs = ["k8s/namespace.yaml"],
)
