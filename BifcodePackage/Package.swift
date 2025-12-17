// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "BifcodeFeature",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "BifcodeFeature",
            targets: ["BifcodeFeature"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/CodeEditApp/CodeEditSourceEditor", from: "0.12.0"),
    ],
    targets: [
        .target(
            name: "BifcodeFeature",
            dependencies: [
                .product(name: "CodeEditSourceEditor", package: "CodeEditSourceEditor"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "BifcodeFeatureTests",
            dependencies: [
                "BifcodeFeature",
            ]
        ),
    ]
)
