func Home(request: HTTPRequest) -> HTTPResponse {
    return HTTPResponse.text(
        statusCode: 200,
        reason: "OK",
        body: "Hello from raw TCP Swift HTTP server.\n"
    )
}

func Hello(request: HTTPRequest) -> HTTPResponse {
    return HTTPResponse.text(
        statusCode: 200,
        reason: "OK",
        body: "Hello, World!\n"
    )
}

func Coding(request: HTTPRequest) -> HTTPResponse {
    return HTTPResponse.text(
        statusCode: 200,
        reason: "OK",
        body: "ABSOLUTE CODING!!!\n"
    )
}

func Kazu(request: HTTPRequest) -> HTTPResponse {
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

func HTML(request: HTTPRequest) -> HTTPResponse {
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
