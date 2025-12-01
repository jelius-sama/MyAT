#if canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#endif

/*
 * Pointer aliases to keep the scary names away.
 */
typealias CString = UnsafeMutablePointer<CChar>
typealias OptionalCString = UnsafeMutablePointer<Optional<CChar>>

typealias ConstCString = UnsafePointer<CChar>
typealias OptionalConstCString = UnsafePointer<Optional<CChar>>

typealias CStringPtr = UnsafeMutablePointer<CString>
typealias OptionalCStringPtr = UnsafeMutablePointer<Optional<CString>>

typealias ConstCStringPtr = UnsafePointer<ConstCString>
typealias OptionalConstCStringPtr = UnsafePointer<Optional<ConstCString>>

typealias CPtr = UnsafeMutableRawPointer
typealias ConstCPtr = UnsafeRawPointer

/*
 * Basic HTTP request representation.
 */
public struct HTTPRequest {
    public let method: String
    public let path: String
    public let version: String
    public let headers: Dictionary<String, String>
    public let body: Array<UInt8>
}

/*
 * Basic HTTP response representation.
 */
public struct HTTPResponse {
    public let statusCode: Int
    public let reasonPhrase: String
    public var headers: Dictionary<String, String>
    public var body: Array<UInt8>

    /*
     * Serialize response to HTTP/1.1 wire format.
     */
    public func serialize() -> Array<UInt8> {
        var buffer = Array<UInt8>()
        let statusLine = "HTTP/1.1 \(statusCode) \(reasonPhrase)\r\n"
        buffer.append(contentsOf: Array(statusLine.utf8))

        var localHeaders = headers
        localHeaders["Content-Length"] = String(body.count)

        for (key, value) in localHeaders {
            let line = "\(key): \(value)\r\n"
            buffer.append(contentsOf: Array(line.utf8))
        }
        buffer.append(contentsOf: Array<UInt8>(Array("\r\n".utf8)))
        buffer.append(contentsOf: body)
        return buffer
    }

    /*
     * Build a plain text response quickly.
     */
    public static func text(
        statusCode: Int,
        reason: String,
        body: String
    ) -> HTTPResponse {
        let bytes = Array(body.utf8)
        var headers = Dictionary<String, String>()
        headers["Content-Type"] = "text/plain; charset=utf-8"
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: headers,
            body: bytes
        )
    }

    /*
     * Build a response from an asset.
     */
    public static func fromAsset(
        asset: Asset,
        statusCode: Int = 200,
        reason: String = "OK"
    ) -> HTTPResponse {
        var headers = Dictionary<String, String>()
        headers["Content-Type"] = asset.mimeType
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: headers,
            body: asset.data
        )
    }
}

/*
 * HTTP handler type used by the router.
 */
public typealias HTTPHandler = (HTTPRequest) -> HTTPResponse

/*
 * Simple router: method + path -> handler.
 */
public final class Router {
    private var routes: Dictionary<String, Dictionary<String, HTTPHandler>> =
        Dictionary<String, Dictionary<String, HTTPHandler>>()

    public init() {}

    /*
     * Register a handler for a given method and path.
     */
    public func register(
        method: String,
        path: String,
        handler: @escaping HTTPHandler
    ) {
        var methodRoutes =
            routes[method] ?? Dictionary<String, HTTPHandler>()
        methodRoutes[path] = handler
        routes[method] = methodRoutes
    }

    /*
     * Route a request. If no handler is found, return 404.
     */
    public func route(request: HTTPRequest) -> HTTPResponse {
        if let methodRoutes = routes[request.method],
            let handler = methodRoutes[request.path]
        {
            return handler(request)
        }

        return HTTPResponse.text(
            statusCode: 404,
            reason: "Not Found",
            body: "404 Not Found"
        )
    }
}

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

    /*
     * Very small MIME type map based on file extension.
     */
    private func guessMimeType(path: String) -> String {
        if path.hasSuffix(".html") || path.hasSuffix(".htm") {
            return "text/html; charset=utf-8"
        }
        if path.hasSuffix(".css") {
            return "text/css; charset=utf-8"
        }
        if path.hasSuffix(".js") {
            return "application/javascript; charset=utf-8"
        }
        if path.hasSuffix(".json") {
            return "application/json; charset=utf-8"
        }
        if path.hasSuffix(".png") {
            return "image/png"
        }
        if path.hasSuffix(".jpg") || path.hasSuffix(".jpeg") {
            return "image/jpeg"
        }
        if path.hasSuffix(".gif") {
            return "image/gif"
        }
        if path.hasSuffix(".txt") {
            return "text/plain; charset=utf-8"
        }
        return "application/octet-stream"
    }
}

/*
 * Context passed into a client handler thread.
 */
final class ClientContext {
    let server: HTTPServer
    let clientFD: Int32

    init(server: HTTPServer, clientFD: Int32) {
        self.server = server
        self.clientFD = clientFD
    }
}

/*
 * HTTP server that owns the listening socket and dispatches to Router.
 */
public final class HTTPServer {
    private let port: UInt16
    private let router: Router
    private let assetManager: Optional<AssetManager>

    public init(
        port: UInt16,
        router: Router,
        assetManager: Optional<AssetManager> = Optional<AssetManager>.none
    ) {
        self.port = port
        self.router = router
        self.assetManager = assetManager
    }

    /*
     * Start the server. This will block the calling thread and spawn a
     * new thread for each incoming connection.
     */
    public func start() {
        let listenFD = socket(AF_INET, Int32(SOCK_STREAM), 0)
        if listenFD < 0 {
            perror("socket")
            return
        }

        var opt: Int32 = 1
        let optLen = socklen_t(MemoryLayout<Int32>.size)
        if setsockopt(
            listenFD,
            Int32(SOL_SOCKET),
            Int32(SO_REUSEADDR),
            &opt,
            optLen
        ) != 0 {
            perror("setsockopt")
            close(listenFD)
            return
        }

        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = htons(port)
        addr.sin_addr = in_addr(s_addr: in_addr_t(0)) /* INADDR_ANY */

        let bindResult = withUnsafePointer(to: &addr) { ptr -> Int32 in
            let sockPtr = UnsafeRawPointer(ptr).assumingMemoryBound(
                to: sockaddr.self
            )
            return bind(
                listenFD,
                sockPtr,
                socklen_t(MemoryLayout<sockaddr_in>.size)
            )
        }

        if bindResult != 0 {
            perror("bind")
            close(listenFD)
            return
        }

        if listen(listenFD, SOMAXCONN) != 0 {
            perror("listen")
            close(listenFD)
            return
        }

        print("HTTPServer listening on port \(port)")

        /*
         * Accept loop: each client handled by a separate pthread.
         */
        while true {
            var clientAddr = sockaddr()
            var clientLen = socklen_t(MemoryLayout<sockaddr>.size)

            let clientFD = withUnsafeMutablePointer(to: &clientAddr) {
                ptr
                    -> Int32 in
                let sockPtr = UnsafeMutableRawPointer(ptr)
                    .assumingMemoryBound(to: sockaddr.self)
                return accept(
                    listenFD,
                    sockPtr,
                    &clientLen
                )
            }

            if clientFD < 0 {
                perror("accept")
                continue
            }

            let context = ClientContext(server: self, clientFD: clientFD)
            let unmanaged =
                Unmanaged.passRetained(context)
            let rawPtr = unmanaged.toOpaque()

            var thread: pthread_t? = nil
            let result = pthread_create(
                &thread,
                nil,
                clientThreadEntry,
                rawPtr
            )
            if result != 0 {
                print("Failed to create thread: \(result)")
                unmanaged.release()
                close(clientFD)
            } else {
                /*
                 * We do not need to join on this thread; detach so that
                 * resources are cleaned when it exits.
                 */
                pthread_detach(thread)
            }
        }
    }

    /*
     * Parse HTTP request from client, route it, and send response.
     * Handles a single request then closes the connection.
     */
    fileprivate func handleClient(fd: Int32) {
        var buffer = Array<UInt8>()
        let tempSize = 4096

        var headerParsed = false
        var headerBytes: Array<UInt8> = Array<UInt8>()

        while !headerParsed {
            var temp = Array<UInt8>(repeating: 0, count: tempSize)
            let bytesRead = temp.withUnsafeMutableBytes { rawBuf -> Int in
                let ptr = rawBuf.baseAddress!
                return Int(read(fd, ptr, tempSize))
            }

            if bytesRead <= 0 {
                close(fd)
                return
            }

            temp.removeSubrange(bytesRead..<tempSize)
            buffer.append(contentsOf: temp)

            if let range = findHeaderEnd(in: buffer) {
                headerParsed = true
                let headerEndIndex = range.upperBound
                headerBytes = Array(buffer[..<headerEndIndex])
                /* For now we ignore any body; this is fine for GET. */
            }
        }

        guard
            let requestString =
                String(validating: headerBytes, as: UTF8.self)
        else {
            close(fd)
            return
        }

        let request = parseRequest(from: requestString)

        /*
         * Example: simple static file handler prefix.
         * If the path starts with "/static/" and an asset manager
         * is provided, we let it serve the file.
         */
        let response: HTTPResponse

        if let assets = assetManager,
            request.method == "GET",
            request.path.hasPrefix("/static/")
        {

            let index = request.path.index(
                request.path.startIndex,
                offsetBy: "/static/".count
            )
            let rel = "/" + String(request.path[index...])
            if let asset = assets.loadAsset(relativePath: rel) {
                response = HTTPResponse.fromAsset(asset: asset)
            } else {
                response = HTTPResponse.text(
                    statusCode: 404,
                    reason: "Not Found",
                    body: "Asset not found"
                )
            }

        } else {
            response = router.route(request: request)
        }

        let bytes = response.serialize()
        _ = bytes.withUnsafeBytes { rawBuf -> Int in
            let ptr = rawBuf.baseAddress!
            return Int(write(fd, ptr, bytes.count))
        }

        close(fd)
    }

    /*
     * Find the index of "\r\n\r\n" in the buffer.
     */
    private func findHeaderEnd(
        in buffer: Array<UInt8>
    ) -> Optional<Range<Int>> {
        if buffer.count < 4 {
            return Optional<Range<Int>>.none
        }

        let pattern = Array<UInt8>(Array("\r\n\r\n".utf8))
        let maxIndex = buffer.count - pattern.count

        var i = 0
        while i <= maxIndex {
            var matched = true
            var j = 0
            while j < pattern.count {
                if buffer[i + j] != pattern[j] {
                    matched = false
                    break
                }
                j += 1
            }
            if matched {
                let range = i..<(i + pattern.count)
                return Optional<Range<Int>>.some(range)
            }
            i += 1
        }

        return Optional<Range<Int>>.none
    }

    /*
     * Very small HTTP/1.1 parser: request line + headers.
     * Body is ignored for now, which is fine for GET and simple use.
     */
    private func parseRequest(from raw: String) -> HTTPRequest {
        let lines = raw.split(separator: "\r\n", omittingEmptySubsequences: false)
        var method = "GET"
        var path = "/"
        var version = "HTTP/1.1"

        if lines.count > 0 {
            let requestLineParts = lines[0].split(separator: " ")
            if requestLineParts.count >= 3 {
                method = String(requestLineParts[0])
                path = String(requestLineParts[1])
                version = String(requestLineParts[2])
            }
        }

        var headers = Dictionary<String, String>()
        if lines.count > 1 {
            var index = 1
            while index < lines.count {
                let line = lines[index]
                index += 1
                if line.isEmpty {
                    break
                }

                if let separatorIndex = line.firstIndex(of: ":") {
                    let name = String(line[..<separatorIndex])
                        .trimmingCharacters(in: .whitespaces)
                    let valueStart =
                        line.index(after: separatorIndex)
                    let value = String(line[valueStart...])
                        .trimmingCharacters(in: .whitespaces)
                    headers[name] = value
                }
            }
        }

        let body = Array<UInt8>()
        return HTTPRequest(
            method: method,
            path: path,
            version: version,
            headers: headers,
            body: body
        )
    }
}

/*
 * Thread entry point compatible with pthread_create.
 */
private func clientThreadEntry(arg: CPtr?) -> CPtr? {
    guard let arg = arg else {
        return nil
    }
    let unmanaged = Unmanaged<ClientContext>.fromOpaque(
        ConstCPtr(arg)
    )
    let context = unmanaged.takeRetainedValue()
    context.server.handleClient(fd: context.clientFD)
    return nil
}

/*
 * Small helper to trim whitespace on Swift.String without pulling in
 * extra utilities.
 */
private extension String {
    func trimmingCharacters(
        in characterSet: CharacterSet
    ) -> String {
        var start = startIndex
        var end = index(before: endIndex)

        while start <= end
            && characterSet.contains(
                unicodeScalars[start].value
            )
        {
            start = index(after: start)
        }

        while end >= start
            && characterSet.contains(
                unicodeScalars[end].value
            )
        {
            end = index(before: end)
        }

        if start > end {
            return ""
        }

        return String(self[start...end])
    }
}

/*
 * Very small CharacterSet stand-in for whitespace trimming.
 */
private struct CharacterSet {
    private let scalars: Set<UInt32>

    static let whitespaces: CharacterSet = {
        let list: Array<UInt32> = Array<UInt32>(
            arrayLiteral: 9, 10, 11, 12, 13, 32
        )
        return CharacterSet(scalars: Set(list))
    }()

    init(scalars: Set<UInt32>) {
        self.scalars = scalars
    }

    func contains(_ value: UInt32) -> Bool {
        return scalars.contains(value)
    }
}

/*
 * ===== Example wiring / "main" =====
 *
 * You can replace this with your own routes and asset directory.
 */

let router = Router()

router.register(method: "GET", path: "/") { _ in
    HTTPResponse.text(
        statusCode: 200,
        reason: "OK",
        body: "Hello from raw TCP Swift HTTP server.\n"
    )
}

let assetManager = AssetManager(root: "./Assets")

let server = HTTPServer(
    port: 6969,
    router: router,
    assetManager: Optional<AssetManager>.some(assetManager)
)

server.start()
