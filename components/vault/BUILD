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
    name = "vault-namespace",
    srcs = ["deployment/vault-namespace.yaml"],
)

# ==============================================================================
# Deploy Vault
# ==============================================================================
kustomize_prep(
    name = "kustomize-vault",
    srcs = glob(["deployment/**/*.yaml"]),
)

#
# BAREMETAL
#
kustomize(
    name = "vault-baremetal-components",
    namespace = "vault",
    kustomize_path = "deployment",
    overlay = "baremetal",
    srcs = [":kustomize-vault"],
)

filegroup(
    name = "vault-baremetal-helm-values",
    srcs = [
        "deployment/overlays/baremetal/helm-values.yaml",
    ],
)

helm_chart(
    name = "vault-baremetal-helm",
    src = "//third_party:helm-vault-tar",
    install_path = "vault-helm-0.13.0/",
    namespace = "vault",
    visibility = ["//components/vault/..."],
    values_file = ":vault-baremetal-helm-values",
    deps = [
        ":vault-namespace",
        ":vault-baremetal-helm-values"
    ]
)

#
# MINIKUBE
#
filegroup(
    name = "vault-minikube-helm-values",
    srcs = [
        "deployment/overlays/minikube/helm-values.yaml",
    ],
)

helm_chart(
    name = "vault-minikube-helm",
    src = "//third_party:helm-vault-tar",
    install_path = "vault-helm-0.13.0/",
    namespace = "vault",
    visibility = ["//components/vault/..."],
    values_file = ":vault-minikube-helm-values",
    deps = [
        ":vault-namespace",
        ":vault-minikube-helm-values"
    ]
)

# ==============================================================================
# Initialize Vault and enable Kubernetes backend
# ==============================================================================
sh_binary(
    name = "vault-init",
    main = "setup/vault-init.sh",
)

sh_binary(
    name = "vault-unseal",
    main = "setup/vault-unseal.sh"
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
