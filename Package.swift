// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "Madog",
                      platforms: [.iOS(.v11)],
                      products: [
                          .library(name: "Madog", targets: ["Madog"])
                      ],
                      dependencies: [
                          .package(url: "https://github.com/cerihughes/provident.git", .branch("simplify"))
                      ],
                      targets: [
                          .target(name: "Madog",
                                  dependencies: ["Provident"],
                                  path: "Source"),
                          .testTarget(name: "MadogTests",
                                      dependencies: ["Madog"],
                                      path: "Tests"),
                      ])
