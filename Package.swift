import PackageDescription
import Foundation

let package = Package(
    name: "LibStorj",
    targets: [
        Target(name: "LibStorj")
    ],
    dependencies: [
        .Package(url: "https://github.com/Ybrin/CLibStorj.git", majorVersion: 1)
    ],
    exclude: []
)
