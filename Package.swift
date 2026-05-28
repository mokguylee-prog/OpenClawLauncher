// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "OpenClawLauncher",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "OpenClawLauncher", targets: ["OpenClawLauncher"]),
    ],
    targets: [
        .executableTarget(
            name: "OpenClawLauncher",
            dependencies: [],
            path: "Sources/OpenLauncher",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
