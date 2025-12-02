func InitRouter() -> Router {
    let router = Router()

    /*
     * Global middleware: Analytics and logging for all requests.
     */
    router.use { request in
        print("[\(request.method)] \(request.path)")
        return Optional<HTTPResponse>.none
    }

    /*
     * Global middleware: Add a custom server header to all responses.
     * Note: This would need response middleware support, so we skip for now.
     */

    /*
     * API logging middleware - logs detailed info for API routes.
     */
    let apiLogger: Middleware = { request in
        print("API Request:")
        print("  Method: \(request.method)")
        print("  Path: \(request.path)")
        print("  Headers: \(request.headers)")
        return Optional<HTTPResponse>.none
    }

    /*
     * Auth middleware - example of short-circuiting.
     */
    let requireAuth: Middleware = { request in
        if let token = request.headers["Authorization"] {
            if token == "Bearer secret-token" {
                return Optional<HTTPResponse>.none
            }
        }
        return Optional<HTTPResponse>.some(
            HTTPResponse.json(
                statusCode: 401,
                reason: "Unauthorized",
                body: "{\"error\": \"Unauthorized\"}"
            )
        )
    }

    /*
     * Basic routes with plain text responses.
     */
    router.register(method: "GET", path: "/") { _ in
        HTTPResponse.text(
            statusCode: 200,
            reason: "OK",
            body: "Hello from raw TCP Swift HTTP server.\n"
        )
    }

    router.register(method: "GET", path: "/hello") { _ in
        HTTPResponse.text(
            statusCode: 200,
            reason: "OK",
            body: "Hello, World!\n"
        )
    }

    router.register(method: "GET", path: "/coding") { _ in
        HTTPResponse.text(
            statusCode: 200,
            reason: "OK",
            body: "ABSOLUTE CODING!!!\n"
        )
    }

    router.register(method: "GET", path: "/kazu") { _ in
        var customHeaders = HTTPHeaders()
        customHeaders["X-Custom-Header"] = "Kazu-specific"
        customHeaders["X-Greeting"] = "Hello!"

        return HTTPResponse.text(
            statusCode: 200,
            reason: "OK",
            body: "Hello Kazu-kun!\n",
            headers: customHeaders
        )
    }

    /*
     * HTML response example.
     */
    router.register(method: "GET", path: "/html") { _ in
        let htmlContent = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>MyAT Server</title>
            </head>
            <body>
                <h1>Welcome to MyAT!</h1>
                <p>This is an HTML response from our Swift HTTP server.</p>
            </body>
            </html>
            """

        return HTTPResponse.html(
            statusCode: 200,
            reason: "OK",
            body: htmlContent
        )
    }

    /*
     * JSON response example with API logging middleware.
     */
    router.register(
        method: "GET",
        path: "/api/status",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { _ in
        let jsonBody = """
            {
                "status": "ok",
                "version": "1.0.0",
                "server": "MyAT"
            }
            """

        return HTTPResponse.json(
            statusCode: 200,
            reason: "OK",
            body: jsonBody
        )
    }

    /*
     * Protected API endpoint with auth middleware.
     */
    router.register(
        method: "GET",
        path: "/api/protected",
        middleware: Array<Middleware>(arrayLiteral: apiLogger, requireAuth)
    ) { request in
        let jsonBody = """
            {
                "message": "You have access to protected data!",
                "user": "authenticated"
            }
            """

        return HTTPResponse.json(
            statusCode: 200,
            reason: "OK",
            body: jsonBody
        )
    }

    /*
     * Example with custom response headers.
     */
    router.register(method: "GET", path: "/api/data") { _ in
        var customHeaders = HTTPHeaders()
        customHeaders["X-API-Version"] = "1.0"
        customHeaders["X-Rate-Limit"] = "100"
        customHeaders["Cache-Control"] = "no-cache"

        let jsonBody = """
            {
                "data": [1, 2, 3, 4, 5],
                "count": 5
            }
            """

        return HTTPResponse.json(
            statusCode: 200,
            reason: "OK",
            body: jsonBody,
            headers: customHeaders
        )
    }

    return router
}
