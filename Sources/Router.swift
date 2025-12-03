import Foundation

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
        if !request.body.isEmpty {
            print("  Body Size: \(request.body.count) bytes")
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
     * Custom 404 handler with builder pattern.
     */
    let notFoundBuilder = router.setNotFoundHandler()
        .forAssets(prefix: "/static/") { request in
            let htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Asset Not Found</title>
                    <style>
                        body { font-family: sans-serif; text-align: center; padding: 50px; }
                        h1 { color: #e74c3c; }
                    </style>
                </head>
                <body>
                    <h1>404 - Asset Not Found</h1>
                    <p>The requested asset <code>\(request.path)</code> could not be found.</p>
                </body>
                </html>
                """
            return HTTPResponse.html(
                statusCode: 404,
                reason: "Not Found",
                body: htmlContent
            )
        }
        .forAPI(prefix: "/api/") { request in
            let jsonBody = """
                {
                    "error": "Not Found",
                    "message": "The API endpoint [\(request.method)] \(request.path) does not exist.",
                    "status": 404,
                    "timestamp": "\(Date())"
                }
                """
            return HTTPResponse.json(
                statusCode: 404,
                reason: "Not Found",
                body: jsonBody
            )
        }
        .default { request in
            let htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Page Not Found</title>
                    <style>
                        body { font-family: sans-serif; text-align: center; padding: 50px; }
                        h1 { color: #2c3e50; }
                        a { color: #3498db; text-decoration: none; }
                    </style>
                </head>
                <body>
                    <h1>404 - Page Not Found</h1>
                    <p>The page you're looking for doesn't exist.</p>
                    <a href="/">Go back home</a>
                </body>
                </html>
                """
            return HTTPResponse.html(
                statusCode: 404,
                reason: "Not Found",
                body: htmlContent
            )
        }

    router.finalize404Handler(builder: notFoundBuilder)

    /*
     * Basic static routes with plain text responses.
     */
    router.register(method: "GET", path: "/") { req in return Home(request: req) }

    router.register(method: "GET", path: "/processor") { req in return HTMLExample(request: req) }

    router.register(method: "GET", path: "/hello") { req in return Hello(request: req) }

    router.register(method: "GET", path: "/coding") { req in return Coding(request: req) }

    router.register(method: "GET", path: "/kazu") { req in return Kazu(request: req) }

    router.register(method: "GET", path: "/html") { req in return HTML(request: req) }

    router.register(
        method: "GET",
        path: "/api/status",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in JsonBody(request: req) }

    router.register(
        method: "GET",
        path: "/api/protected",
        middleware: Array<Middleware>(arrayLiteral: apiLogger, requireAuth)
    ) { req in return Protected(request: req) }

    router.register(method: "GET", path: "/api/data") { req in return Data(request: req) }

    /*
     * Dynamic route: Get user by ID.
     */
    router.register(
        method: "GET",
        path: "/users/:id",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in return User(request: req) }

    /*
     * POST: Create a new user.
     */
    router.register(
        method: "POST",
        path: "/users",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in return Post(request: req) }

    /*
     * PUT: Update user by ID.
     */
    router.register(
        method: "PUT",
        path: "/users/:id",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in return Put(request: req) }

    /*
     * PATCH: Partially update user by ID.
     */
    router.register(
        method: "PATCH",
        path: "/users/:id",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in return Patch(request: req) }

    /*
     * DELETE: Delete user by ID.
     */
    router.register(
        method: "DELETE",
        path: "/users/:id",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in return Delete(request: req) }

    /*
     * HEAD: Get user metadata without body.
     */
    router.register(
        method: "HEAD",
        path: "/users/:id"
    ) { req in return Head(request: req) }

    /*
     * OPTIONS: Return allowed methods for a resource.
     */
    router.register(method: "OPTIONS", path: "/users/:id") { req in return Options(request: req) }

    /*
     * Dynamic route: Get specific comment on a post.
     */
    router.register(
        method: "GET",
        path: "/posts/:postId/comments/:commentId",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in return GetComments(request: req) }

    /*
     * POST: Create a comment on a post.
     */
    router.register(
        method: "POST",
        path: "/posts/:postId/comments",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in PostComments(request: req) }

    /*
     * Static route that takes precedence over dynamic route.
     */
    router.register(
        method: "GET",
        path: "/users/me",
        middleware: Array<Middleware>(arrayLiteral: apiLogger)
    ) { req in return Static(request: req) }

    /*
     * Dynamic route: Product categories and products.
     */
    router.register(
        method: "GET",
        path: "/products/:category/:productId"
    ) { req in Product(request: req) }

    return router
}
