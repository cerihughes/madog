// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Madog",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Madog", targets: ["Madog"])
    ],
    targets: [
        .target(name: "Madog", path: "MadogCore"),
        .testTarget(name: "MadogTests", dependencies: ["Madog"], path: "Tests")
    ]
)
