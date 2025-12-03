import Foundation

func AssetNotfound(request: HTTPRequest) -> HTTPResponse {
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

func APINotfound(request: HTTPRequest) -> HTTPResponse {
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

func DefaultNotfound(request: HTTPRequest) -> HTTPResponse {
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
