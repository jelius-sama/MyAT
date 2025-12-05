func ComponentExample(request: HTTPRequest) -> HTTPResponse {
    let cardAndButtonJS =
        ShCard.render(varName: "c1")
        + ShCard.header(into: "c1", varName: "c1h")
            + """
            c1h.textContent = "Continue watching";
            """
        + ShCard.content(into: "c1", varName: "c1c")
            + """
            c1c.textContent = "Episode 4 / 12";
            """
        + ShCard.footer(into: "c1", varName: "c1f")
        + ShButton.render(varName: "resumeBtn", text: "Resume", variant: "default")
            + """
            c1f.appendChild(resumeBtn);
            """

    let compJS =
        JSProcessor.process {
            JSStatement(code: "function initApp() {")
            JSStatement(code: cardAndButtonJS)
            JSStatement(
                code: """
                    const root = document.getElementById("root");
                    root.appendChild(c1);
                    """
            )
            JSStatement(code: "}")
            JSStatement(code: "document.addEventListener('DOMContentLoaded', initApp);")
        }

    let htmlContent = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>AniTrack · Home</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif;
                    background: #f5f5f7;
                    padding: 30px;
                }
                .sh-btn {
                    border-radius: 6px;
                    font-size: 0.875rem;
                    padding: 6px 12px;
                    font-weight: 500;
                    cursor: pointer;
                    border: 1px solid transparent;
                    transition: background 0.15s ease;
                }
                .sh-btn-default { background: #000; color: white; }
                .sh-btn-default:hover { background: #222; }

                .sh-card {
                    border: 1px solid #e4e4e7;
                    border-radius: 10px;
                    background: #ffffff;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.04);
                    width: 330px;
                }
                .sh-card-header,
                .sh-card-content,
                .sh-card-footer {
                    padding: 14px;
                }
                .sh-card-content {
                    padding-top: 0;
                }
            </style>
        </head>
        <body>
            <div id="root"></div>
            <script>
                \(compJS)
            </script>
        </body>
        </html>
        """

    return HTTPResponse.html(statusCode: 200, reason: "OK", body: htmlContent)
}
