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
# Deploy Vault - MINIKUBE
# ==============================================================================
k8s_config(
    name = "vault-namespace",
    srcs = ["deployment/vault-namespace.yaml"],
)

filegroup(
    name = "vault-helm-values",
    srcs = [
        "deployment/vault-helm-values.yaml",
    ],
)

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

# ==============================================================================
# Deploy Vault - BAREMETAL
# ==============================================================================
k8s_config(
    name = "vault-baremetal-pv",
    srcs = ["baremetal/vault-pv.yaml"],
)

filegroup(
    name = "vault-baremetal-helm-values",
    srcs = [
        "baremetal/vault-helm-values.yaml",
    ],
)

helm_chart(
    name = "vault-baremetal-helm",
    src = "//third_party:helm-vault-tar",
    install_path = "vault-helm-0.6.0/",
    namespace = "vault",
    visibility = ["//components/vault/..."],
    values_file = ":vault-baremetal-helm-values",
    deps = [
        ":vault-namespace",
        ":vault-baremetal-helm-values"
    ]
)

k8s_config(
    name = "vault-baremetal-ingress",
    srcs = ["baremetal/vault-ui-ingress.yaml"],
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
filegroup(
    name = "agent-policy",
    srcs = [
        "setup/agent-policy.json",
    ],
)

sh_binary(
    name = "agent-init",
    main = "setup/agent-init.sh",
    data = [
        ":agent-policy"
    ],
    deps = [
        ":agent-policy"
    ]
)

# ==============================================================================
# Sample deployment
# ==============================================================================
k8s_config(
    name = "k8s-sample-deployment",
    srcs = [
        "sample/agent-service-account.yaml",
        "sample/sample-deployment.yaml"
    ],
)

sh_binary(
    name = "sample-deployment",
    main = "sample/deploy.sh",
)
