// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Madog",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Madog", targets: ["Madog"])
    ],
    dependencies: [
        .package(url: "https://github.com/cerihughes/madog-core", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/kif-framework/KIF", .upToNextMajor(from: "3.8.0"))
    ],
    targets: [
        .target(name: "Madog", dependencies: ["MadogContainers_iOS"], path: "Madog"),
        .target(
            name: "MadogContainers_iOS",
            dependencies: [
                .product(name: "MadogCore", package: "madog-core")
            ],
            path: "MadogContainers_iOS"
        ),
        .testTarget(
            name: "MadogContainersTests_iOS",
            dependencies: ["MadogContainers_iOS", "KIF"],
            path: "MadogContainersTests_iOS"
        )
    ]
)
