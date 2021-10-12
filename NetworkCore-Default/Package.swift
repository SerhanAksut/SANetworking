// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkCore-Default",
    products: [
        .library(
            name: "NetworkCore-Default",
            targets: ["NetworkCore-Default"]
        ),
    ],
    dependencies: [
        .package(path: "Common")
    ],
    targets: [
        .target(
            name: "NetworkCore-Default",
            dependencies: [
                "Common",
                .product(name: "Helpers", package: "Common")
            ]
        ),
        .testTarget(
            name: "NetworkCore-DefaultTests",
            dependencies: ["NetworkCore-Default"]
        ),
    ]
)
