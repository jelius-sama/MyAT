func GetComments(request: HTTPRequest) -> HTTPResponse {
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

func PostComments(request: HTTPRequest) -> HTTPResponse {
    guard let postId = request.pathParameters["postId"] else {
        return HTTPResponse.json(
            statusCode: 400,
            reason: "Bad Request",
            body: "{\"error\": \"Missing post ID\"}"
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
            "message": "Comment created on post \(postId)",
            "receivedData": "\(bodyString)"
        }
        """

    return HTTPResponse.json(
        statusCode: 201,
        reason: "Created",
        body: jsonBody
    )
}

func Static(request: HTTPRequest) -> HTTPResponse {
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

func Product(request: HTTPRequest) -> HTTPResponse {
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
