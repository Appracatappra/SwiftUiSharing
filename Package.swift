// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUiSharing",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftUiSharing",
            targets: ["SwiftUiSharing"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/Appracatappra/SwiftletUtilities.git", from: "1.0.0"),
        .package(url: "https://github.com/johnxnguyen/Down.git", from: "0.11.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftUiSharing",
            dependencies: ["SwiftletUtilities", "Down"]),
        .testTarget(
            name: "SwiftUiSharingTests",
            dependencies: ["SwiftUiSharing"]),
    ]
)
