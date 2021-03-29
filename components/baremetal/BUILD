subinclude("//build_defs:docker")
subinclude("//build_defs:helm_chart")
subinclude("//build_defs:k8s")

sh_binary(
    name = "deploy",
    main = "deploy.sh",
)

# ==============================================================================
# NGINX
# ==============================================================================
k8s_config(
    name = "nginx-operator",
    srcs = ["//third_party:nginx-operator"],
)

# ==============================================================================
# METALLB
# ==============================================================================
k8s_config(
    name = "metallb-namespace",
    srcs = ["//third_party:metallb-namespace"],
)

k8s_config(
    name = "metallb-deployment",
    srcs = ["//third_party:metallb-deployment"],
)

k8s_config(
    name = "metallb-config",
    srcs = ["k8s/metallb-config.yaml"],
)

# ==============================================================================
# HAPROXY
# ==============================================================================
helm_chart(
    name = "haproxy-helm",
    src = "//third_party:helm-haproxy-tar",
    install_path = "haproxy-ingress",
    namespace = "haproxy",
    visibility = ["//components/baremetal/..."],
    values_file = ":haproxy-ingress-values",
    deps = [
        ":haproxy-namespace",
        ":haproxy-ingress-values"
    ]
)

k8s_config(
    name = "haproxy-namespace",
    srcs = ["k8s/haproxy-namespace.yaml"],
)

filegroup(
    name = "haproxy-ingress-values",
    srcs = [
        "k8s/haproxy-ingress-values.yaml",
    ],
)

# ==============================================================================
# SAMPLES
# ==============================================================================
k8s_config(
    name = "sample-ingress",
    srcs = ["k8s/sample-ingress.yaml"],
)

k8s_config(
    name = "sample-pvc",
    srcs = ["k8s/sample-pvc.yaml"],
)
