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
    name = "vault-helm",
    src = "//third_party:helm-vault-tar",
    install_path = "vault-helm-0.6.0/",
    namespace = "vault",
    visibility = ["//components/vault/..."],
    values_file = ":vault-helm-values",
    deps = [
        ":vault-namespace",
        ":vault-helm-values"
    ]
)

k8s_config(
    name = "vault-namespace",
    srcs = ["k8s/vault-namespace.yaml"],
)

filegroup(
    name = "vault-helm-values",
    srcs = [
        "setup/vault-values.yaml",
    ],
)

# ==============================================================================
# Initialize Vault and enable Kubernetes backend
# ==============================================================================
sh_binary(
    name = "vault-init",
    main = "setup/vault-init.sh",
)

# ==============================================================================
# Setup sidecar Agent
# ==============================================================================
sh_binary(
    name = "agent-init",
    main = "setup/agent-init.sh",
    data = [
        ":agent-values"
    ],
    deps = [
        ":agent-values"
    ]
)

filegroup(
    name = "agent-values",
    srcs = [
        "setup/agent-policy.json",
    ],
)

k8s_config(
    name = "agent-service-account",
    srcs = ["k8s/agent-service-account.yaml"],
)

# ==============================================================================
# Sample deployment
# ==============================================================================
k8s_config(
    name = "k8s-sample-deployment",
    srcs = ["k8s/sample-deployment.yaml"],
)

sh_binary(
    name = "sample-deployment",
    main = "sample.sh",
)