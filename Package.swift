// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomAlertPackage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CustomAlertPackage",
            targets: ["CustomAlertPackage"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CustomAlertPackage",
            resources: [.process("Resources/Assets.xcassets")]),
        .testTarget(
            name: "CustomAlertPackageTests",
            dependencies: ["CustomAlertPackage"]),
    ]
)
