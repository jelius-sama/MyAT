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
     * API logging middleware - logs detailed info for API routes.
     */
    let apiLogger: Middleware = { request in
        print("API Request:")
        print("  Method: \(request.method)")
        print("  Path: \(request.path)")
        print("  Headers: \(request.headers)")
        if !request.pathParameters.isEmpty {
            print("  Path Parameters: \(request.pathParameters)")
        }
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
     * Custom 404 handler.
     */
    router.setNotFoundHandler { request in
        let jsonBody = """
            {
                "error": "Not Found",
                "message": "The requested resource [\(request.method)] \(request.path) was not found.",
                "status": 404
            }
            """

        return HTTPResponse.json(
            statusCode: 404,
            reason: "Not Found",
            body: jsonBody
        )
    }

    /*
     * Basic static routes with plain text responses.
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

    /*
     * Dynamic route: Get user by ID.
     */
    router.register(
        method: "GET",
        path: "/users/:id",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { request in
        guard let userId = request.pathParameters["id"] else {
            return HTTPResponse.json(
                statusCode: 400,
                reason: "Bad Request",
                body: "{\"error\": \"Missing user ID\"}"
            )
        }

        let jsonBody = """
            {
                "id": "\(userId)",
                "name": "User \(userId)",
                "email": "user\(userId)@example.com"
            }
            """

        return HTTPResponse.json(
            statusCode: 200,
            reason: "OK",
            body: jsonBody
        )
    }

    /*
     * Dynamic route: Get specific comment on a post.
     */
    router.register(
        method: "GET",
        path: "/posts/:postId/comments/:commentId",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { request in
        guard let postId = request.pathParameters["postId"],
            let commentId = request.pathParameters["commentId"]
        else {
            return HTTPResponse.json(
                statusCode: 400,
                reason: "Bad Request",
                body: "{\"error\": \"Missing parameters\"}"
            )
        }

        let jsonBody = """
            {
                "postId": "\(postId)",
                "commentId": "\(commentId)",
                "author": "Anonymous",
                "text": "This is comment \(commentId) on post \(postId)"
            }
            """

        return HTTPResponse.json(
            statusCode: 200,
            reason: "OK",
            body: jsonBody
        )
    }

    /*
     * Static route that might conflict with dynamic route.
     * This will take precedence over /users/:id when path is exactly "/users/me"
     */
    router.register(
        method: "GET",
        path: "/users/me",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { request in
        let jsonBody = """
            {
                "id": "current",
                "name": "Current User",
                "email": "me@example.com",
                "note": "This is the static /users/me route"
            }
            """

        return HTTPResponse.json(
            statusCode: 200,
            reason: "OK",
            body: jsonBody
        )
    }

    /*
     * Dynamic route: Product categories and products.
     */
    router.register(
        method: "GET",
        path: "/products/:category/:productId"
    ) { request in
        guard let category = request.pathParameters["category"],
            let productId = request.pathParameters["productId"]
        else {
            return HTTPResponse.json(
                statusCode: 400,
                reason: "Bad Request",
                body: "{\"error\": \"Missing parameters\"}"
            )
        }

        let jsonBody = """
            {
                "category": "\(category)",
                "productId": "\(productId)",
                "name": "Product \(productId)",
                "price": 99.99
            }
            """

        return HTTPResponse.json(
            statusCode: 200,
            reason: "OK",
            body: jsonBody
        )
    }

    /*
     * This will cause a fatal error if uncommented because it's a duplicate:
     * router.register(method: "GET", path: "/users/:id") { _ in
     *     HTTPResponse.text(body: "Duplicate!")
     * }
     */

    return router
}
