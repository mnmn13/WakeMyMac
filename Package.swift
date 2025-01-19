// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "WakeMyMac",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "wake-my-mac",
            targets: ["WakeMyMac"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "WakeMyMac",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "WakeMyMac",
//            exclude: ["Tests"],
//            resources: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
            ],
            linkerSettings: [
                .linkedFramework("IOKit")
            ]
        )//,
//        .testTarget(
//            name: "WakeMyMacTests",
//            dependencies: ["WakeMyMac"],
//            path: "WakeMyMacTests"
//        )
    ]
)
