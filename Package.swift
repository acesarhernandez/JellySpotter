// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "JellySpotter",
    platforms: [
        .tvOS(.v17),
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "JellySpotterCore",
            targets: ["JellySpotterCore"]
        )
    ],
    targets: [
        .target(
            name: "JellySpotterCore"
        ),
        .testTarget(
            name: "JellySpotterCoreTests",
            dependencies: ["JellySpotterCore"]
        )
    ]
)

