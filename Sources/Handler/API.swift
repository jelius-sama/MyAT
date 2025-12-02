func JsonBody(request: HTTPRequest) -> HTTPResponse {
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

func Protected(request: HTTPRequest) -> HTTPResponse {
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

func Data(request: HTTPRequest) -> HTTPResponse {
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

func User(request: HTTPRequest) -> HTTPResponse {
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
