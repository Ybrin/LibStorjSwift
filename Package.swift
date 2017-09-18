// swift-tools-version:4.0
import PackageDescription
import Foundation

let package = Package(
    name: "LibStorj",
    products: [
        .library(name: "LibStorj", targets: ["LibStorj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Ybrin/CLibStorj.git", from: "1.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "LibStorj", dependencies: ["CLibStorj", "SwiftyJSON"]),
        .testTarget(name: "LibStorjTests", dependencies: ["LibStorj"]),
    ],
    swiftLanguageVersions: [3]
)
