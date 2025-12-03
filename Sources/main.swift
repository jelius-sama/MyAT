// let exePath = CommandLine.arguments[0]
// let exeURL = URL(fileURLWithPath: exePath).standardizedFileURL
// let exeDir = exeURL.deletingLastPathComponent()
// let parentDir = exeDir.deletingLastPathComponent()
// let assetsDir = parentDir.appendingPathComponent("Assets").path
// let assetManager = AssetManager(root: assetsDir)

// if !FileManager.default.fileExists(atPath: assetsDir) {
//     print("⚠️ Warning: Assets directory not found at \(assetsDir)")
// }

let server = HTTPServer(
    port: 6969,
    router: InitRouter(),
    assetManager: Optional<AssetManager>.some(
        AssetManager(useEmbedded: true))
)

server.start()
