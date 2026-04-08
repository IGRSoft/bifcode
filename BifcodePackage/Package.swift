// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "BifcodeFeature",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "BifcodeFeature",
            targets: ["BifcodeFeature"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CodeEditApp/CodeEditSourceEditor", from: "0.15.0"),
        .package(url: "https://github.com/IGRSoft/DeveloperSupportStore", from: "1.0.3")
    ],
    targets: [
        .target(
            name: "BifcodeFeature",
            dependencies: [
                .product(name: "CodeEditSourceEditor", package: "CodeEditSourceEditor"),
                .product(name: "DeveloperSupportStore", package: "DeveloperSupportStore")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "BifcodeFeatureTests",
            dependencies: [
                "BifcodeFeature"
            ]
        )
    ]
)
