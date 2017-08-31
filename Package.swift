import PackageDescription
import Foundation

// Run install dependencies
/*
@discardableResult
func shell(_ args: String...) -> Int32 {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

if shell("./install-dependencies.sh") != 0 {
  let err = "./install-dependencies.sh failed! Please open an issue on Github."
  print("\u{001B}[0;33\(err)")
  return
}
*/

let package = Package(
    name: "LibStorj",
    targets: [
        Target(name: "LibStorj")
    ],
    dependencies: [
        .Package(url: "../CLibStorj", majorVersion: 1)
    ],
    exclude: []
)
