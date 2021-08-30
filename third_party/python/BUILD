package(
    default_visibility = ["PUBLIC"],
    python_wheel_repo = "pypi.org",
    python_wheel_name_scheme = [
        "{url_base}/{package_name}-{version}-${{OS}}_${{ARCH}}.whl",
        "{url_base}/{package_name}-{version}.whl",
        "https://files.pythonhosted.org/packages/py3/{initial}/{package_name}/{package_name}-{version}-py3-none-any.whl",
        "https://files.pythonhosted.org/packages/py2.py3/{initial}/{package_name}/{package_name}-{version}-py2.py3-none-any.whl",
    ],
)

pip_library(
    name = "neo4j",
    version = "4.3.1",
    hashes = ["dd53a8ad3d26878ec48c2fdb7774bf5dc0634a024b65e62894db89324a99a65d"],
)

pip_library(
    name = "neobolt",
    version = "1.7.17",
    hashes = ["5b8cb9c155180bd1521e4df36da74cb75ba5dc7a5e36046d74bad4e6cedfc10f"],
)

pip_library(
    name = "neotime",
    version = "1.7.4",
    hashes = ["481df3ea864383c4cf30b80be04d16235d518f17886c5b6613a11590ad9ecadc"],
)

python_wheel(
    name = "botocore",
    hashes = ["3f719fed8184cda9f7ed84747cd5b344d42557712f225f93dd183721410ce01c"],
    version = "1.20.98",
)
