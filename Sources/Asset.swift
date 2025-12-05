#if canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#endif

import Foundation
import Utils

/*
 * Represents a loaded asset (file contents + MIME type).
 */
public struct Asset {
    public let path: String
    public let mimeType: String
    public let data: Array<UInt8>
}

/*
 * Asset manager that loads files from embedded assets and/or disk.
 * Embedded assets take precedence over disk files when both exist.
 */
public final class AssetManager {
    private let root: Optional<String>
    private let useEmbedded: Bool
    private let pathPrefix: String

    /*
     * Initialize AssetManager with at least one source (embedded or filesystem).
     *
     * Parameters:
     *   - root: Optional filesystem root directory for assets
     *   - useEmbedded: Whether to use embedded assets (default: false)
     *   - pathPrefix: Optional prefix for asset paths (default: "/static/")
     *
     * At least one of root or useEmbedded must be provided.
     */
    public init(
        root: Optional<String> = nil, useEmbedded: Bool = false, pathPrefix: String = "/static/"
    ) {
        guard root != nil || useEmbedded else {
            fatalError(
                "AssetManager requires at least one asset source: provide either 'root' or set 'useEmbedded' to true"
            )
        }

        self.root = root
        self.useEmbedded = useEmbedded
        self.pathPrefix = pathPrefix
    }

    /*
     * Retrieve the current asset path prefix.
     * - Returns: A `String` representing the asset path prefix,
     *            defaulting to `"/static/"`.
     */
    public func getPathPrefix() -> String {
        return pathPrefix
    }

    /*
     * Resolve and load an asset by a relative HTTP path.
     * For example `/static/index.html` -> `index.html`
     *
     * Search order:
     * 1. Embedded assets (if enabled)
     * 2. Filesystem (if root is provided)
     */
    public func loadAsset(relativePath: String) -> Optional<Asset> {
        var cleanPath = relativePath
        if cleanPath.hasPrefix("/") {
            let index = cleanPath.index(after: cleanPath.startIndex)
            cleanPath = String(cleanPath[index...])
        }

        // Try embedded assets first (they take precedence)
        if useEmbedded {
            if let embeddedAsset = loadFromEmbedded(cleanPath: cleanPath) {
                return Optional<Asset>.some(embeddedAsset)
            }
        }

        // Fall back to filesystem if root is provided
        guard let root = root else {
            return Optional<Asset>.none
        }

        return loadFromFilesystem(cleanPath: cleanPath, root: root)
    }

    private func loadFromEmbedded(cleanPath: String) -> Optional<Asset> {
        // Convert Swift String to C string
        let cPath = cleanPath.withCString { ptr -> CString in
            let length = strlen(ptr)
            let buffer = malloc(length + 1)
                .assumingMemoryBound(to: CChar.self)
            strcpy(buffer, ptr)
            return buffer
        }

        defer {
            free(cPath)
        }

        // Check if asset exists
        let exists = AssetExists(cPath)
        guard exists == 1 else {
            return Optional<Asset>.none
        }

        // Get size
        var size: Int32 = 0

        // Get data
        guard let cData = GetEmbeddedAssetData(cPath, &size) else {
            return Optional<Asset>.none
        }

        defer {
            FreeString(cData)
        }

        // Convert C data to Swift array
        let dataPtr = UnsafeRawPointer(cData)
        let bufferPtr = dataPtr.bindMemory(to: UInt8.self, capacity: Int(size))
        let data = Array<UInt8>(UnsafeBufferPointer(start: bufferPtr, count: Int(size)))

        // Get MIME type
        var mimeType = "application/octet-stream"
        if let cMime = GetEmbeddedAssetMimeType(cPath) {
            mimeType = String(cString: cMime)
            FreeString(cMime)
        }

        return Optional<Asset>.some(
            Asset(
                path: "embedded:/\(cleanPath)",
                mimeType: mimeType,
                data: data
            ))
    }

    private func loadFromFilesystem(cleanPath: String, root: String) -> Optional<Asset> {
        let fullPath = root + "/" + cleanPath

        let cPath = fullPath.withCString { ptr -> CString in
            let length = strlen(ptr)
            let buffer = malloc(length + 1)
                .assumingMemoryBound(to: CChar.self)
            strcpy(buffer, ptr)
            return buffer
        }

        let fd = open(cPath, O_RDONLY)
        defer {
            free(cPath)
        }

        if fd < 0 {
            return Optional<Asset>.none
        }

        var statBuf = stat()
        if fstat(fd, &statBuf) != 0 {
            close(fd)
            return Optional<Asset>.none
        }

        let fileSize = Int(statBuf.st_size)
        var data = Array<UInt8>(repeating: 0, count: fileSize)
        let bytesRead = data.withUnsafeMutableBytes { rawBuf -> Int in
            let base = rawBuf.baseAddress!
            return Int(read(fd, base, fileSize))
        }

        close(fd)

        if bytesRead <= 0 {
            return Optional<Asset>.none
        }

        if bytesRead < fileSize {
            data.removeSubrange(bytesRead..<fileSize)
        }

        var mime = "application/octet-stream"
        if let cMime = GuessMimeType(cPath) {
            mime = String(cString: cMime)
            FreeString(cMime)
        }

        let asset = Asset(
            path: fullPath,
            mimeType: mime,
            data: data
        )

        return Optional<Asset>.some(asset)
    }
}
