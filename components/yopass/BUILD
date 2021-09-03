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
    name = "yopass-namespace",
    srcs = ["deployment/yopass-namespace.yaml"],
)

# ==============================================================================
# YOPASS
# ==============================================================================
kustomize_prep(
    name = "kustomize-yopass",
    srcs = glob(["deployment/**/*.yaml"]),
)

kustomize(
    name = "yopass-baremetal",
    namespace = "yopass",
    kustomize_path = "deployment/",
    overlay = "baremetal",
    srcs = [":kustomize-yopass"],
)

kustomize(
    name = "yopass-minikube",
    namespace = "yopass",
    kustomize_path = "deployment/",
    overlay = "minikube",
    srcs = [":kustomize-yopass"],
)
