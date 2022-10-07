// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    products: [
        .library(name: "AdventOfCode", targets: ["AdventOfCode"]),
        .executable(name: "AdventOfCode2021", targets: ["AdventOfCode2021"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AdventOfCode",
            dependencies: []),
        .target(
            name: "Helpers",
            dependencies: [],
            path: "Sources/Helpers"),
        .target(
            name: "AdventOfCode2021",
            dependencies: ["Helpers"],
            path: "Sources/AdventOfCode2021"),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: ["AdventOfCode"]),
        .testTarget(
            name: "AdventOfCode2021Tests",
            dependencies: ["AdventOfCode2021"]),
        .testTarget(
            name: "HelpersTests",
            dependencies: ["Helpers"]),
    ]
)
