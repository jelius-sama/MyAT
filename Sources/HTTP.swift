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
 * Type alias for path parameters extracted from dynamic routes.
 */
public typealias PathParameters = Dictionary<String, String>

/*
 * Basic HTTP request representation.
 */
public final class HTTPRequest {
    public let method: String
    public let path: String
    public let version: String
    public let headers: HTTPHeaders
    public let body: Array<UInt8>
    public var pathParameters: PathParameters

    public init(
        method: String,
        path: String,
        version: String,
        headers: HTTPHeaders,
        body: Array<UInt8>,
        pathParameters: PathParameters = PathParameters()
    ) {
        self.method = method
        self.path = path
        self.version = version
        self.headers = headers
        self.body = body
        self.pathParameters = pathParameters
    }
}

/*
 * Basic HTTP response representation.
 */
public final class HTTPResponse {
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
     * Build an XML response.
     */
    public static func xml(
        statusCode: Int = 200,
        reason: String = "OK",
        body: String,
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponse {
        let bytes = Array(body.utf8)
        var responseHeaders = headers
        responseHeaders["Content-Type"] = "application/xml; charset=utf-8"
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: responseHeaders,
            body: bytes
        )
    }

    /*
     * Build an JS response.
     */
    public static func js(
        statusCode: Int = 200,
        reason: String = "OK",
        body: String,
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponse {
        let bytes = Array(body.utf8)
        var responseHeaders = headers
        responseHeaders["Content-Type"] = "application/javascript; charset=utf-8"
        return HTTPResponse(
            statusCode: statusCode,
            reasonPhrase: reason,
            headers: responseHeaders,
            body: bytes
        )
    }

    /*
     * Build an CSS response.
     */
    public static func css(
        statusCode: Int = 200,
        reason: String = "OK",
        body: String,
        headers: HTTPHeaders = HTTPHeaders()
    ) -> HTTPResponse {
        let bytes = Array(body.utf8)
        var responseHeaders = headers
        responseHeaders["Content-Type"] = "text/css; charset=utf-8"
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
 * Route pattern types: static or dynamic with parameters.
 */
internal enum RoutePattern {
    case staticRoute(path: String)
    case dynamicRoute(segments: Array<RouteSegment>)
}

/*
 * Route segment for dynamic routing.
 */
internal enum RouteSegment {
    case literal(String)
    case parameter(String)
}

/*
 * Route entry that holds handler, middleware, and pattern info.
 */
internal struct RouteEntry {
    let pattern: RoutePattern
    let handler: HTTPHandler
    let middleware: Array<Middleware>
    let originalPath: String
}

/*
 * Not found handler configuration with builder pattern.
 */
public final class NotFoundHandlerBuilder {
    private var assetHandlers: Array<(String, Optional<HTTPHandler>)> = Array<
        (String, Optional<HTTPHandler>)
    >()
    private var apiHandlers: Array<(String, HTTPHandler)> = Array<(String, HTTPHandler)>()
    private var defaultHandler: Optional<HTTPHandler> = Optional<HTTPHandler>.none
    private var assetPathPrefix: String

    internal init(assetPathPrefix: String) {
        self.assetPathPrefix = assetPathPrefix
    }

    /*
     * Set handler for asset 404 errors (e.g., /static/).
     */
    public func forAssets(
        handler: @escaping HTTPHandler
    ) -> NotFoundHandlerBuilder {
        assetHandlers.append((assetPathPrefix, handler))
        return self
    }

    /*
     * Set handler for API 404 errors with a specific prefix.
     */
    public func forAPI(
        prefix: String,
        handler: @escaping HTTPHandler
    ) -> NotFoundHandlerBuilder {
        apiHandlers.append((prefix, handler))
        return self
    }

    /*
     * Set the default 404 handler.
     */
    public func `default`(handler: @escaping HTTPHandler) -> NotFoundHandlerBuilder {
        defaultHandler = Optional<HTTPHandler>.some(handler)
        return self
    }

    /*
     * Build the final handler that checks all conditions.
     */
    internal func build() -> HTTPHandler {
        return { request in
            /*
             * Check asset handler first.
             */
            for (prefix, handler) in self.assetHandlers {
                if request.path.hasPrefix(prefix) {
                    if let handler = handler {
                        return handler(request)
                    }
                }
            }

            /*
             * Check API handlers.
             */
            for (prefix, handler) in self.apiHandlers {
                if request.path.hasPrefix(prefix) {
                    return handler(request)
                }
            }

            /*
             * Default handler or fallback.
             */
            if let defaultH = self.defaultHandler {
                return defaultH(request)
            }

            return HTTPResponse.text(
                statusCode: 404,
                reason: "Not Found",
                body: "404 Not Found"
            )
        }
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
 * Router with support for static and dynamic routes, middleware,
 * and custom 404 handlers.
 */
public final class Router {
    private var routes: Dictionary<String, Array<RouteEntry>> =
        Dictionary<String, Array<RouteEntry>>()

    private var globalMiddleware: Array<Middleware> = Array<Middleware>()

    private var notFoundHandler: Optional<HTTPHandler> = Optional<HTTPHandler>.none
    private var assetPathPrefix: String

    public init(assetPathPrefix: String) {
        self.assetPathPrefix = assetPathPrefix
    }

    /*
     * Register global middleware that runs for all routes.
     */
    public func use(middleware: @escaping Middleware) {
        globalMiddleware.append(middleware)
    }

    /*
     * Set a custom 404 handler with builder pattern.
     */
    public func setNotFoundHandler() -> NotFoundHandlerBuilder {
        let builder = NotFoundHandlerBuilder(assetPathPrefix: assetPathPrefix)
        return builder
    }

    /*
     * Finalize the 404 handler from builder.
     */
    public func finalize404Handler(builder: NotFoundHandlerBuilder) {
        notFoundHandler = Optional<HTTPHandler>.some(builder.build())
    }

    /*
     * Register a handler for a given method and path with optional middleware.
     * Supports dynamic routes with :parameter syntax.
     * Examples:
     *   - Static: "/users"
     *   - Dynamic: "/users/:id"
     *   - Dynamic: "/posts/:postId/comments/:commentId"
     */
    public func register(
        method: String,
        path: String,
        middleware: Array<Middleware> = Array<Middleware>(),
        handler: @escaping HTTPHandler
    ) {
        let pattern = parseRoutePath(path: path)
        let entry = RouteEntry(
            pattern: pattern,
            handler: handler,
            middleware: middleware,
            originalPath: path
        )

        /*
         * Get existing routes for this method.
         */
        var methodRoutes = routes[method] ?? Array<RouteEntry>()

        /*
         * Check for exact duplicates (same method + same path).
         */
        for existing in methodRoutes {
            if existing.originalPath == path {
                fatalError(
                    "Route collision detected: [\(method)] \(path) "
                        + "is already registered."
                )
            }
        }

        /*
         * Check for static vs dynamic conflicts.
         */
        if case .staticRoute(let staticPath) = pattern {
            for existing in methodRoutes {
                if case .dynamicRoute = existing.pattern {
                    if matchesPattern(
                        path: staticPath,
                        pattern: existing.pattern
                    ) != nil {
                        print(
                            "⚠️  Warning: Static route [\(method)] \(path) "
                                + "shadows dynamic route \(existing.originalPath). "
                                + "Static route will take precedence."
                        )
                    }
                }
            }
        }

        methodRoutes.append(entry)
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
         * Find matching route entry.
         */
        guard let methodRoutes = routes[request.method] else {
            return handleNotFound(request: request)
        }

        /*
         * Try static routes first, then dynamic routes.
         */
        var staticMatch: Optional<RouteEntry> = Optional<RouteEntry>.none
        var dynamicMatch: Optional<(RouteEntry, PathParameters)> =
            Optional<(RouteEntry, PathParameters)>.none

        for entry in methodRoutes {
            switch entry.pattern {
            case .staticRoute(let staticPath):
                if staticPath == request.path {
                    staticMatch = Optional<RouteEntry>.some(entry)
                    break
                }
            case .dynamicRoute:
                if let params = matchesPattern(
                    path: request.path,
                    pattern: entry.pattern
                ) {
                    dynamicMatch = Optional<(RouteEntry, PathParameters)>.some(
                        (entry, params)
                    )
                }
            }
        }

        /*
         * Static routes take precedence over dynamic routes.
         */
        let matchedEntry: RouteEntry
        var pathParams = PathParameters()

        if let staticEntry = staticMatch {
            matchedEntry = staticEntry
        } else if let (dynamicEntry, params) = dynamicMatch {
            matchedEntry = dynamicEntry
            pathParams = params
        } else {
            return handleNotFound(request: request)
        }

        /*
         * Create request with path parameters.
         */
        let requestWithParams = request
        requestWithParams.pathParameters = pathParams

        /*
         * Execute route-specific middleware.
         */
        for mw in matchedEntry.middleware {
            if let response = mw(requestWithParams) {
                return response
            }
        }

        /*
         * Execute the handler.
         */
        return matchedEntry.handler(requestWithParams)
    }

    /*
     * Handle 404 with custom handler or default.
     */
    internal func handleNotFound(request: HTTPRequest) -> HTTPResponse {
        if let handler = notFoundHandler {
            return handler(request)
        }

        return HTTPResponse.text(
            statusCode: 404,
            reason: "Not Found",
            body: "404 Not Found"
        )
    }

    /*
     * Parse route path into pattern (static or dynamic).
     */
    private func parseRoutePath(path: String) -> RoutePattern {
        let components = path.split(separator: "/")
        var segments = Array<RouteSegment>()
        var isDynamic = false

        for component in components {
            let part = String(component)
            if part.hasPrefix(":") {
                let paramName = String(part.dropFirst())
                segments.append(RouteSegment.parameter(paramName))
                isDynamic = true
            } else {
                segments.append(RouteSegment.literal(part))
            }
        }

        if isDynamic {
            return RoutePattern.dynamicRoute(segments: segments)
        } else {
            return RoutePattern.staticRoute(path: path)
        }
    }

    /*
     * Match a request path against a route pattern.
     * Returns path parameters if matched, none otherwise.
     */
    private func matchesPattern(
        path: String,
        pattern: RoutePattern
    ) -> Optional<PathParameters> {
        switch pattern {
        case .staticRoute(let staticPath):
            return path == staticPath
                ? Optional<PathParameters>.some(PathParameters())
                : Optional<PathParameters>.none

        case .dynamicRoute(let segments):
            let pathComponents = path.split(separator: "/")

            if pathComponents.count != segments.count {
                return Optional<PathParameters>.none
            }

            var params = PathParameters()

            var index = 0
            while index < segments.count {
                let segment = segments[index]
                let component = String(pathComponents[index])

                switch segment {
                case .literal(let expected):
                    if component != expected {
                        return Optional<PathParameters>.none
                    }
                case .parameter(let name):
                    params[name] = component
                }

                index += 1
            }

            return Optional<PathParameters>.some(params)
        }
    }
}

/*
 * HTTP server that owns the listening socket and dispatches to Router.
 */
public final class HTTPServer {
    private let port: UInt16
    private let router: Router
    private let assetManager: Optional<AssetManager>
    private let parser: HTTPParser

    public init(
        port: UInt16,
        router: Router,
        assetManager: Optional<AssetManager> = Optional<AssetManager>.none
    ) {
        self.port = port
        self.router = router
        self.assetManager = assetManager
        self.parser = HTTPParser()
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
     * Handles request body parsing based on Content-Length.
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

            if let range = parser.findHeaderEnd(in: buffer) {
                headerParsed = true
                let headerEndIndex = range.upperBound
                headerBytes = Array(buffer[..<headerEndIndex])

                /*
                 * Keep any bytes after the header end for body parsing.
                 */
                if headerEndIndex < buffer.count {
                    let bodyStart = buffer[headerEndIndex...]
                    buffer = Array(bodyStart)
                } else {
                    buffer = Array<UInt8>()
                }
            }
        }

        guard
            let requestString =
                String(validating: headerBytes, as: UTF8.self)
        else {
            close(fd)
            return
        }

        var request = parser.parseRequest(from: requestString)

        /*
         * Parse request body if Content-Length is present.
         */
        if let contentLengthStr = request.headers["Content-Length"],
            let contentLength = Int(contentLengthStr),
            contentLength > 0
        {
            var bodyBytes = buffer
            let remainingBytes = contentLength - bodyBytes.count

            /*
             * Read remaining body bytes if needed.
             */
            if remainingBytes > 0 {
                var remaining = remainingBytes
                while remaining > 0 {
                    var temp = Array<UInt8>(repeating: 0, count: min(tempSize, remaining))
                    let len = temp.count
                    let bytesRead = temp.withUnsafeMutableBytes { rawBuf -> Int in
                        let ptr = rawBuf.baseAddress!
                        return Int(read(fd, ptr, len))
                    }

                    if bytesRead <= 0 {
                        break
                    }

                    temp.removeSubrange(bytesRead..<temp.count)
                    bodyBytes.append(contentsOf: temp)
                    remaining -= bytesRead
                }
            }

            /*
             * Update request with parsed body.
             */
            request = HTTPRequest(
                method: request.method,
                path: request.path,
                version: request.version,
                headers: request.headers,
                body: bodyBytes,
                pathParameters: request.pathParameters
            )
        }

        /*
         * Handle static file serving with custom 404.
         */
        let response: HTTPResponse

        if let assets = assetManager,
            request.method == "GET",
            request.path.hasPrefix(assets.getPathPrefix())
        {
            let index = request.path.index(
                request.path.startIndex,
                offsetBy: assets.getPathPrefix().count
            )
            let rel = "/" + String(request.path[index...])
            if let asset = assets.loadAsset(relativePath: rel) {
                response = HTTPResponse.fromAsset(asset: asset)
            } else {
                /*
                 * Use router's 404 handler for assets.
                 */
                response = router.handleNotFound(request: request)
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
