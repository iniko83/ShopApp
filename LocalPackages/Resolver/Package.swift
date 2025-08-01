// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Resolver",
  products: [
    .library(
      name: "Resolver",
      targets: ["Resolver"]
    ),
  ],
  targets: [
    .target(name: "Resolver"),
    .testTarget(
      name: "ResolverTests",
      dependencies: ["Resolver"]
    ),
  ]
)
