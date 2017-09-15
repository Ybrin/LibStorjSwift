import PackageDescription
import Foundation

let package = Package(
    name: "LibStorj",
    targets: [
        Target(name: "LibStorj")
    ],
    dependencies: [
        .Package(url: "https://github.com/Ybrin/CLibStorj.git", majorVersion: 1),
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1, 0, 0)..<Version(3, .max, .max))
    ],
    exclude: []
)
