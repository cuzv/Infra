load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_bundle")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Infra",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    data = [
        ":InfraResources",
    ],
    module_name = "Infra",
    visibility = [
        "//visibility:public",
    ],
)

apple_resource_bundle(
    name = "InfraResources",
    bundle_name = "Infra",
    resources = glob([
        "Resources/*",
    ]),
)
