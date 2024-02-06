// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransactionsFeature",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "TransactionsFeature",
            targets: ["TransactionsFeature"]),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Data", path: "../Data")
    ],
    targets: [
        .target(
            name: "TransactionsFeature",
            dependencies: [
                .product(name: "UseCase", package: "Domain"),
                .product(name: "Entities", package: "Domain"),
                .product(name: "Repositories", package: "Data")
        ],
            resources: [.process("Resources")]),
    ]
)
