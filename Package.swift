// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UMKit",
    platforms: [
        .iOS(.v10), .tvOS(.v10), .watchOS(.v4)
    ],
    products: [
        .library(
            name: "UMKit",
            targets: ["UMKit"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UMKit",
            dependencies: []),
        .testTarget(
            name: "UMKitTests",
            dependencies: ["UMKit"])
    ]
)
