package(default_visibility = ["PUBLIC"])

remote_file(
    name = "k8s",
    url = "https://raw.githubusercontent.com/thought-machine/pleasings/master/k8s/k8s.build_defs",
)

remote_file(
    name = "docker",
    url = "https://raw.githubusercontent.com/thought-machine/pleasings/master/docker/docker.build_defs"
)

filegroup(
    name = "helm_chart",
    srcs = ["helm.build_defs"],
)
