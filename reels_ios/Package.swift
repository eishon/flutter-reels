// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ReelsIOS",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ReelsIOS",
            targets: ["ReelsIOS"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ReelsIOS",
            dependencies: [],
            path: "Sources/ReelsIOS"
        ),
    ]
)
