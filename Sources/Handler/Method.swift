func Post(request: HTTPRequest) -> HTTPResponse {
    guard !request.body.isEmpty else {
        return HTTPResponse.json(
            statusCode: 400,
            reason: "Bad Request",
            body: "{\"error\": \"Request body is required\"}"
        )
    }

    let bodyString = String(decoding: request.body, as: UTF8.self)
    print("Received body: \(bodyString)")

    let jsonBody = """
        {
            "message": "User created successfully",
            "receivedData": "\(bodyString)"
        }
        """

    return HTTPResponse.json(
        statusCode: 201,
        reason: "Created",
        body: jsonBody
    )
}

func Put(request: HTTPRequest) -> HTTPResponse {
    guard let userId = request.pathParameters["id"] else {
        return HTTPResponse.json(
            statusCode: 400,
            reason: "Bad Request",
            body: "{\"error\": \"Missing user ID\"}"
        )
    }

    guard !request.body.isEmpty else {
        return HTTPResponse.json(
            statusCode: 400,
            reason: "Bad Request",
            body: "{\"error\": \"Request body is required\"}"
        )
    }

    let bodyString = String(decoding: request.body, as: UTF8.self)

    let jsonBody = """
        {
            "message": "User \(userId) updated successfully",
            "receivedData": "\(bodyString)"
        }
        """

    return HTTPResponse.json(
        statusCode: 200,
        reason: "OK",
        body: jsonBody
    )
}

func Patch(request: HTTPRequest) -> HTTPResponse {
    guard let userId = request.pathParameters["id"] else {
        return HTTPResponse.json(
            statusCode: 400,
            reason: "Bad Request",
            body: "{\"error\": \"Missing user ID\"}"
        )
    }

    guard !request.body.isEmpty else {
        return HTTPResponse.json(
            statusCode: 400,
            reason: "Bad Request",
            body: "{\"error\": \"Request body is required\"}"
        )
    }

    let bodyString = String(decoding: request.body, as: UTF8.self)

    let jsonBody = """
        {
            "message": "User \(userId) partially updated",
            "receivedData": "\(bodyString)"
        }
        """

    return HTTPResponse.json(
        statusCode: 200,
        reason: "OK",
        body: jsonBody
    )
}

func Delete(request: HTTPRequest) -> HTTPResponse {
    guard let userId = request.pathParameters["id"] else {
        return HTTPResponse.json(
            statusCode: 400,
            reason: "Bad Request",
            body: "{\"error\": \"Missing user ID\"}"
        )
    }

    let jsonBody = """
        {
            "message": "User \(userId) deleted successfully"
        }
        """

    return HTTPResponse.json(
        statusCode: 200,
        reason: "OK",
        body: jsonBody
    )
}

func Options(request: HTTPRequest) -> HTTPResponse {
    var customHeaders = HTTPHeaders()
    customHeaders["Allow"] = "GET, PUT, PATCH, DELETE, HEAD, OPTIONS"
    customHeaders["Access-Control-Allow-Methods"] =
        "GET, PUT, PATCH, DELETE, HEAD, OPTIONS"
    customHeaders["Access-Control-Allow-Origin"] = "*"

    return HTTPResponse.text(
        statusCode: 200,
        reason: "OK",
        body: "",
        headers: customHeaders
    )
}

func Head(request: HTTPRequest) -> HTTPResponse {
    guard let userId = request.pathParameters["id"] else {
        return HTTPResponse.text(
            statusCode: 400,
            reason: "Bad Request",
            body: ""
        )
    }

    var customHeaders = HTTPHeaders()
    customHeaders["X-User-Exists"] = "true"
    customHeaders["X-User-ID"] = userId

    return HTTPResponse.text(
        statusCode: 200,
        reason: "OK",
        body: "",
        headers: customHeaders
    )
}

func y(request: HTTPRequest) -> HTTPResponse {

}
