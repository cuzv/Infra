// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Infrastructure",
  platforms: [
    .iOS(.v10),
    .macOS(.v10_12),
    .tvOS(.v10),
    .watchOS(.v3),
  ],
  products: [
    .library(
      name: "Infrastructure",
      targets: ["Infrastructure"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Infrastructure",
      path: "Sources"
    ),
    .testTarget(
      name: "InfrastructureTests",
      dependencies: ["Infrastructure"],
      path: "Tests"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
