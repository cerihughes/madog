// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Madog",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Madog", targets: ["Madog"])
    ],
    dependencies: [
        .package(
            name: "MadogCore",
            url: "https://github.com/cerihughes/madog-core",
            .branch("prepare-for-initial-release")
        ),
        .package(name: "KIF", url: "https://github.com/kif-framework/KIF", .exact("3.8.9"))
    ],
    targets: [
        .target(name: "Madog", dependencies: ["MadogContainers_iOS"], path: "Madog"),
        .target(name: "MadogContainers_iOS", dependencies: ["MadogCore"], path: "MadogContainers_iOS"),
        .testTarget(
            name: "MadogContainersTests_iOS",
            dependencies: ["MadogContainers_iOS", "KIF"],
            path: "MadogContainersTests_iOS"
        )
    ]
)
