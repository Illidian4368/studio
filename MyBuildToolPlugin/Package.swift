import PackageDescription

let package = Package(
    name: "MyBuildToolPlugin",
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "MyBuildToolPlugin",
            targets: ["MyBuildToolPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "MyBuildToolPlugin",
            capability: .buildTool()
        ),
    ]
)
