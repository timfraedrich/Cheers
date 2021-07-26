// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cheers",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "Cheers",
            targets: ["Cheers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(
            name: "Cheers",
            dependencies: ["SnapKit"],
            resources: [
                .process("Resources/close.png")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
