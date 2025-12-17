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
        .package(url: "https://github.com/appstefan/HighlightSwift", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "BifcodeFeature",
            dependencies: [
                .product(name: "HighlightSwift", package: "HighlightSwift"),
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
