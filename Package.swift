// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Madog",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Madog", targets: ["MadogCore"])
    ],
    targets: [
        .target(name: "MadogCore", path: "MadogCore"),
        .testTarget(name: "MadogCoreTests", dependencies: ["MadogCore"], path: "Tests")
    ]
)
