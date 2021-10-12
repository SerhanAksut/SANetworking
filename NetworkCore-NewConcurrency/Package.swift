// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkCore-NewConcurrency",
    products: [
        .library(
            name: "NetworkCore-NewConcurrency",
            targets: ["NetworkCore-NewConcurrency"]
        ),
    ],
    dependencies: [
        .package(path: "Common")
    ],
    targets: [
        .target(
            name: "NetworkCore-NewConcurrency",
            dependencies: [
                "Common",
                .product(name: "Helpers", package: "Common")
            ]
        ),
        .testTarget(
            name: "NetworkCore-NewConcurrencyTests",
            dependencies: ["NetworkCore-NewConcurrency"]
        ),
    ]
)
