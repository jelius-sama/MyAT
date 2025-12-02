#if canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#endif

/*
 * Type alias for HTTP headers dictionary.
 */
public typealias HTTPHeaders = Dictionary<String, String>

/*
 * Basic HTTP request representation.
 */
public struct HTTPRequest {
    public let method: String
    public let path: String
    public let version: String
    public let headers: HTTPHeaders
    public let body: Array<UInt8>
}

/*
 * Basic HTTP response representation.
 */
public struct HTTPResponse {
    public let statusCode: Int
    public let reasonPhrase: String
    public var headers: HTTPHeaders
    public var body: Array<UInt8>

    /*
     * Main initializer with all parameters.
     */
    public init(
        statusCode: Int,
        reasonPhrase: String,
        headers: HTTPHeaders,
        body: Array<UInt8>
    ) {
        self.statusCode = statusCode
        self.reasonPhrase = reasonPhrase
        self.headers = headers
        self.body = body
    }

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
        statusCode: Int = 200,
        reason: String = "OK",
        body: String,
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponse {
        let bytes = Array(body.utf8)
        var responseHeaders = headers
        responseHeaders["Content-Type"] = "text/plain; charset=utf-8"
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: responseHeaders,
            body: bytes
        )
    }

    /*
     * Build an HTML response.
     */
    public static func html(
        statusCode: Int = 200,
        reason: String = "OK",
        body: String,
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponse {
        let bytes = Array(body.utf8)
        var responseHeaders = headers
        responseHeaders["Content-Type"] = "text/html; charset=utf-8"
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: responseHeaders,
            body: bytes
        )
    }

    /*
     * Build a JSON response.
     */
    public static func json(
        statusCode: Int = 200,
        reason: String = "OK",
        body: String,
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponse {
        let bytes = Array(body.utf8)
        var responseHeaders = headers
        responseHeaders["Content-Type"] = "application/json; charset=utf-8"
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: responseHeaders,
            body: bytes
        )
    }

    /*
     * Build a response from an asset.
     */
    public static func fromAsset(
        asset: Asset,
        statusCode: Int = 200,
        reason: String = "OK",
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponse {
        var responseHeaders = headers
        responseHeaders["Content-Type"] = asset.mimeType
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: responseHeaders,
            body: asset.data
        )
    }
}

/*
 * HTTP handler type used by the router.
 */
public typealias HTTPHandler = (HTTPRequest) -> HTTPResponse

/*
 * Middleware type that can intercept and modify requests/responses.
 * Returns Optional<HTTPResponse>:
 * - .some(response): Short-circuit with this response
 * - .none: Continue to next middleware/handler
 */
public typealias Middleware = (HTTPRequest) -> Optional<HTTPResponse>

/*
 * Route entry that holds handler and optional middleware.
 */
fileprivate struct RouteEntry {
    let handler: HTTPHandler
    let middleware: Array<Middleware>
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
 * Simple router: method + path -> handler with middleware support.
 */
public final class Router {
    private var routes: Dictionary<String, Dictionary<String, RouteEntry>> =
        Dictionary<String, Dictionary<String, RouteEntry>>()

    private var globalMiddleware: Array<Middleware> = Array<Middleware>()

    public init() {}

    /*
     * Register global middleware that runs for all routes.
     */
    public func use(middleware: @escaping Middleware) {
        globalMiddleware.append(middleware)
    }

    /*
     * Register a handler for a given method and path with optional middleware.
     */
    public func register(
        method: String,
        path: String,
        middleware: Array<Middleware> = Array<Middleware>(),
        handler: @escaping HTTPHandler
    ) {
        var methodRoutes =
            routes[method] ?? Dictionary<String, RouteEntry>()
        let entry = RouteEntry(handler: handler, middleware: middleware)
        methodRoutes[path] = entry
        routes[method] = methodRoutes
    }

    /*
     * Route a request through middleware chain and handler.
     * Execution order:
     * 1. Global middleware (can short-circuit)
     * 2. Route-specific middleware (can short-circuit)
     * 3. Handler
     */
    public func route(request: HTTPRequest) -> HTTPResponse {
        /*
         * Execute global middleware first.
         */
        for mw in globalMiddleware {
            if let response = mw(request) {
                return response
            }
        }

        /*
         * Find the route entry.
         */
        guard let methodRoutes = routes[request.method],
            let entry = methodRoutes[request.path]
        else {
            return HTTPResponse.text(
                statusCode: 404,
                reason: "Not Found",
                body: "404 Not Found"
            )
        }

        /*
         * Execute route-specific middleware.
         */
        for mw in entry.middleware {
            if let response = mw(request) {
                return response
            }
        }

        /*
         * Execute the handler.
         */
        return entry.handler(request)
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
        #if canImport(Glibc)
            let sockType = Int32(SOCK_STREAM.rawValue)
        #else
            let sockType = Int32(SOCK_STREAM)
        #endif

        let listenFD = socket(AF_INET, sockType, 0)
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

            #if canImport(Glibc)
                var thread: pthread_t = 0
                let result = pthread_create(
                    &thread,
                    nil,
                    clientThreadEntry,
                    rawPtr
                )
            #else
                var thread: Optional<pthread_t> = nil
                let result = pthread_create(
                    &thread,
                    nil,
                    clientThreadEntry,
                    rawPtr
                )
            #endif

            if result != 0 {
                print("Failed to create thread: \(result)")
                unmanaged.release()
                close(clientFD)
            } else {
                /*
                 * We do not need to join on this thread; detach so that
                 * resources are cleaned when it exits.
                */
                #if canImport(Glibc)
                    pthread_detach(thread)
                #else
                    if let t = thread {
                        pthread_detach(t)
                    }
                #endif
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

        var headers = HTTPHeaders()
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
private func clientThreadEntry(arg: Optional<CPtr>) -> Optional<CPtr> {
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
