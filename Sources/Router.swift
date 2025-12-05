import Foundation

func Sleep(request: HTTPRequest) -> HTTPResponse {
    // sleep for 2 seconds to simulate a slow endpoint
    sleep(2)

    let body = """
        {
            "status": "slept",
            "duration": 2
        }
        """

    return HTTPResponse.json(
        statusCode: 200,
        reason: "OK",
        body: body
    )
}

func InitRouting(router: Router) {
    router.register(method: "GET", path: "/") { req in return Home(request: req) }
    router.register(method: "GET", path: "/sleep") { req in return Sleep(request: req) }
    router.register(method: "GET", path: "/comp") { req in return ComponentExample(request: req) }
}
