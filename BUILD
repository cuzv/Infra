load("@build_bazel_rules_apple//apple:resources.bzl", "apple_resource_bundle")
load("@build_bazel_rules_ios//rules:framework.bzl", "apple_framework")

apple_framework(
    name = "Infra",
    srcs = glob([
        "Sources/**/*.swift",
    ]),
    data = [
        ":InfraResources",
    ],
    platforms = {
        "ios": "12.0",
        "macos": "10.13",
    },
    swift_version = "5.9",
    visibility = [
        "//visibility:public",
    ],
)

apple_resource_bundle(
    name = "InfraResources",
    bundle_name = "Infra",
    # infoplists = [
    #     "Resources/Info.plist",
    # ],
    resources = glob([
        "Resources/*",
    ]),
)
