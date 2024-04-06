// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "VAComparisonView",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "VAComparisonView",
            targets: ["VAComparisonView"]
        ),
    ],
    targets: [
        .target(
            name: "VAComparisonView",
            path: "VAComparisonView/Classes",
            dependencies: []
        ),
    ]
)
