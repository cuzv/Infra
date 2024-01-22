// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Infra",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_13),
    .tvOS(.v12),
    .watchOS(.v4),
  ],
  products: [
    .library(
      name: "Infra",
      targets: ["Infra"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Infra",
      path: "Sources"
    ),
    .testTarget(
      name: "InfraTests",
      dependencies: ["Infra"],
      path: "Tests"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
