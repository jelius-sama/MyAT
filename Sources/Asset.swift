#if canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#endif

import Foundation

/*
 * Represents a loaded asset (file contents + MIME type).
 */
public struct Asset {
    public let path: String
    public let mimeType: String
    public let data: Array<UInt8>
}

/*
 * Asset manager that loads files from disk and guesses MIME types.
 */
public final class AssetManager {
    private let root: String

    public init(root: String) {
        self.root = root
    }

    /*
     * Resolve and load an asset by a relative HTTP path.
     * For example `/static/index.html` -> `${root}/index.html`
     */
    public func loadAsset(relativePath: String) -> Optional<Asset> {
        var cleanPath = relativePath
        if cleanPath.hasPrefix("/") {
            let index = cleanPath.index(after: cleanPath.startIndex)
            cleanPath = String(cleanPath[index...])
        }

        let fullPath = root + "/" + cleanPath

        let cPath = fullPath.withCString { ptr -> CString in
            let length = strlen(ptr)
            let buffer = malloc(length + 1)
                .assumingMemoryBound(to: CChar.self)
            strcpy(buffer, ptr)
            return buffer
        }

        let fd = open(cPath, O_RDONLY)
        free(cPath)

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

        let mime = guessMimeType(path: fullPath)

        let asset = Asset(
            path: fullPath,
            mimeType: mime,
            data: data
        )

        return Optional<Asset>.some(asset)
    }

    private let mimeCache: Dictionary<String, String> = {
        var map = Dictionary<String, String>()

        // Try to read the standard mime.types file
        let mimePaths = [
            "/etc/mime.types",
            "/usr/share/mime/types/mime.types",
        ]

        var text: Optional<String> = nil
        for path in mimePaths {
            if let t = try? String(contentsOfFile: path, encoding: .utf8) {
                text = t
                break
            }
        }

        guard let text = text else {
            return map
        }

        for rawLine in text.split(whereSeparator: \.isNewline) {
            // Trim leading/trailing spaces
            let line = String(rawLine).trimmingCharacters(in: CharacterSet.whitespaces)

            // Skip empty lines and comments
            if line.isEmpty { continue }
            if line.hasPrefix("#") { continue }

            // Split on spaces/tabs
            let parts = line.split { part in part == " " || part == "\t" }
            guard parts.count > 1 else { continue }

            let mime = String(parts[0])
            for extSub in parts.dropFirst() {
                let ext = String(extSub).lowercased()
                map[ext] = mime
            }
        }

        return map
    }()

    private func guessMimeType(path: String) -> String {
        let ext = URL(fileURLWithPath: path).pathExtension.lowercased()

        switch ext {
        case let e where !e.isEmpty:
            if let mime = mimeCache[e] {
                return mime
            }
            return "application/octet-stream"

        default:
            return "application/octet-stream"
        }
    }
}
