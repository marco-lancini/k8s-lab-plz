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
    name = "elk-namespace",
    srcs = ["deployment/elk-namespace.yaml"],
)

# ==============================================================================
# ECK
# ==============================================================================
k8s_config(
    name = "eck",
    srcs = ["//third_party:eck-downloader"],
    visibility = ["//components/elk/..."]
)

kustomize_prep(
    name = "kustomize-elk",
    srcs = glob(["deployment/**/*.yaml"]),
)

kustomize(
    name = "elk-baremetal",
    namespace = "elastic-system",
    kustomize_path = "deployment/",
    overlay = "baremetal",
    srcs = [":kustomize-elk"],
)

kustomize(
    name = "elk-minikube",
    namespace = "elastic-system",
    kustomize_path = "deployment/",
    overlay = "minikube",
    srcs = [":kustomize-elk"],
)
