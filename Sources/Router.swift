func InitRouter() -> Router {
    let router = Router()

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
        HTTPResponse.text(
            statusCode: 200,
            reason: "OK",
            body: "Hello Kazu-kun!\n"
        )
    }

    return router
}
