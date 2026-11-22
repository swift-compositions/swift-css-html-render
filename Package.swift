// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-css-html-render",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "CSS HTML Rendering", targets: ["CSS HTML Rendering"]),
        .library(
            name: "CSS HTML Rendering Test Support",
            targets: ["CSS HTML Rendering Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-compositions/swift-html-render.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-css-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-w3c/swift-w3c-css.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "CSS HTML Rendering",
            dependencies: [
                .product(name: "HTML Rendering", package: "swift-html-render"),
                .product(name: "HTML Rendering Core", package: "swift-html-render"),
                .product(name: "CSS Standard", package: "swift-css-standard"),
                .product(name: "W3C CSS Shared", package: "swift-w3c-css"),
            ]
        ),
        .target(
            name: "CSS HTML Rendering Test Support",
            dependencies: [
                .target(name: "CSS HTML Rendering"),
                .product(name: "CSS Standard", package: "swift-css-standard"),
                .product(name: "HTML Rendering Core Test Support", package: "swift-html-render"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "CSS HTML Rendering Tests",
            dependencies: [
                .target(name: "CSS HTML Rendering"),
                .target(name: "CSS HTML Rendering Test Support"),
            ],
            path: "Tests/CSS HTML Rendering Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
