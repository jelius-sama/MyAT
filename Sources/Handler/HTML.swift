func HTMLExample(request: HTTPRequest) -> HTTPResponse {
    let comprehensiveExample =
        JSProcessor.createAsyncFunction(name: "initApp") {
            console.log(jsString("Initializing app..."))

            // Get the root element
            jsConst("root", value: document.getElementById("root"))

            // Create header
            jsConst("header", value: document.createElement("header"))
            jsVar("header").addClass("app-header")
            jsVar("header").setStyle("backgroundColor", value: "#282c34")
            jsVar("header").setStyle("padding", value: "20px")
            jsVar("header").setStyle("color", value: "white")
            jsVar("header").setStyle("textAlign", value: "center")

            jsConst("title", value: document.createElement("h1"))
            jsVar("title").setTextContent("My Awesome App")
            jsVar("header").appendChild(jsVar("title"))

            // Create main container
            jsConst("container", value: document.createElement("div"))
            jsVar("container").addClass("container")
            jsVar("container").setStyle("padding", value: "20px")
            jsVar("container").setStyle("maxWidth", value: "800px")
            jsVar("container").setStyle("margin", value: "0 auto")

            // Create counter section with control flow
            jsConst("counterSection", value: document.createElement("div"))
            jsVar("counterSection").setStyle("marginBottom", value: "20px")

            jsLet("count", value: jsNumber(0))

            jsConst("counterDisplay", value: document.createElement("h2"))
            jsVar("counterDisplay").setTextContent("Count: 0")
            jsVar("counterDisplay").setStyle("marginBottom", value: "10px")

            jsConst("incrementBtn", value: document.createElement("button"))
            jsVar("incrementBtn").setTextContent("Increment")
            jsVar("incrementBtn").setStyle("padding", value: "10px 20px")
            jsVar("incrementBtn").setStyle("marginRight", value: "10px")
            jsVar("incrementBtn").setStyle("cursor", value: "pointer")

            // Event handler with if/else logic
            jsVar("incrementBtn").addEventListener(
                "click",
                handler: jsArrowFunction(parameters: []) {
                    jsAssign("count", value: jsBinaryOp(jsVarNode("count"), "+", jsNumber(1)))

                    jsIfElse(
                        jsBinaryOp(jsVarNode("count"), ">", jsNumber(10)),
                        then: {
                            jsVar("counterDisplay").setTextContent("Count is high!")
                            jsVar("counterDisplay").setStyle("color", value: "red")
                        },
                        else: {
                            JSStatement(code: "counterDisplay.textContent = `Count: ${count}`")
                            jsVar("counterDisplay").setStyle("color", value: "black")
                        }
                    )
                })

            jsConst("resetBtn", value: document.createElement("button"))
            jsVar("resetBtn").setTextContent("Reset")
            jsVar("resetBtn").setStyle("padding", value: "10px 20px")
            jsVar("resetBtn").setStyle("cursor", value: "pointer")

            jsVar("resetBtn").addEventListener(
                "click",
                handler: jsArrowFunction(parameters: []) {
                    jsAssign("count", value: jsNumber(0))
                    jsVar("counterDisplay").setTextContent("Count: 0")
                    jsVar("counterDisplay").setStyle("color", value: "black")
                })

            jsVar("counterSection").appendChild(jsVar("counterDisplay"))
            jsVar("counterSection").appendChild(jsVar("incrementBtn"))
            jsVar("counterSection").appendChild(jsVar("resetBtn"))

            // Create list with for loop
            jsConst("listSection", value: document.createElement("div"))
            jsVar("listSection").setStyle("marginBottom", value: "20px")

            jsConst("listTitle", value: document.createElement("h3"))
            jsVar("listTitle").setTextContent("Dynamic List")
            jsVar("listSection").appendChild(jsVar("listTitle"))

            jsConst("list", value: document.createElement("ul"))
            jsVar("list").setStyle("listStyle", value: "none")
            jsVar("list").setStyle("padding", value: "0")

            jsFor(variable: "i", from: 1, to: 6) {
                jsConst("item", value: document.createElement("li"))
                jsVar("item").setStyle("padding", value: "10px")
                jsVar("item").setStyle("margin", value: "5px 0")
                jsVar("item").setStyle("backgroundColor", value: "#f0f0f0")
                jsVar("item").setStyle("borderRadius", value: "5px")
                JSStatement(code: "item.textContent = `Item ${i}`")
                jsVar("list").appendChild(jsVar("item"))
            }

            jsVar("listSection").appendChild(jsVar("list"))

            // Create switch statement demo
            jsConst("switchSection", value: document.createElement("div"))
            jsVar("switchSection").setStyle("marginBottom", value: "20px")

            jsConst("switchTitle", value: document.createElement("h3"))
            jsVar("switchTitle").setTextContent("Day of Week")
            jsVar("switchSection").appendChild(jsVar("switchTitle"))

            jsConst("dayDisplay", value: document.createElement("p"))
            jsLet("currentDay", value: jsNumber(3))

            jsSwitch(
                jsVar("currentDay"),
                cases: [
                    jsSwitchCase(jsNumber(1)) {
                        jsVar("dayDisplay").setTextContent("It's Monday!")
                    },
                    jsSwitchCase(jsNumber(2)) {
                        jsVar("dayDisplay").setTextContent("It's Tuesday!")
                    },
                    jsSwitchCase(jsNumber(3)) {
                        jsVar("dayDisplay").setTextContent("It's Wednesday!")
                    },
                    jsSwitchCase(jsNumber(4)) {
                        jsVar("dayDisplay").setTextContent("It's Thursday!")
                    },
                    jsSwitchCase(jsNumber(5)) {
                        jsVar("dayDisplay").setTextContent("It's Friday!")
                    },
                ],
                default: [
                    jsVar("dayDisplay").setTextContent("It's the weekend!")
                ])

            jsVar("switchSection").appendChild(jsVar("dayDisplay"))

            // Create fetch section with try/catch
            jsConst("fetchSection", value: document.createElement("div"))
            jsVar("fetchSection").setStyle("marginBottom", value: "20px")

            jsConst("fetchTitle", value: document.createElement("h3"))
            jsVar("fetchTitle").setTextContent("Fetch Data")
            jsVar("fetchSection").appendChild(jsVar("fetchTitle"))

            jsConst("fetchBtn", value: document.createElement("button"))
            jsVar("fetchBtn").setTextContent("Load Data")
            jsVar("fetchBtn").setStyle("padding", value: "10px 20px")
            jsVar("fetchBtn").setStyle("cursor", value: "pointer")

            jsConst("dataDisplay", value: document.createElement("div"))
            jsVar("dataDisplay").setStyle("marginTop", value: "10px")
            jsVar("dataDisplay").setStyle("padding", value: "10px")
            jsVar("dataDisplay").setStyle("backgroundColor", value: "#e9ecef")
            jsVar("dataDisplay").setStyle("borderRadius", value: "5px")
            jsVar("dataDisplay").setTextContent("Click button to load data")

            jsVar("fetchBtn").addEventListener(
                "click",
                handler: jsAsyncFunction(parameters: []) {
                    jsVar("dataDisplay").setTextContent("Loading...")

                    jsTry {
                        jsConst(
                            "response",
                            value: jsAwait(
                                fetch.get("https://jsonplaceholder.typicode.com/posts/1")))

                        jsIfElse(
                            jsResponse("response").ok(),
                            then: {
                                jsConst("data", value: jsAwait(jsResponse("response").json()))
                                JSStatement(
                                    code:
                                        "dataDisplay.innerHTML = `<strong>Title:</strong> ${data.title}<br><strong>Body:</strong> ${data.body}`"
                                )
                                jsVar("dataDisplay").setStyle("color", value: "green")
                            },
                            else: {
                                jsThrow(jsError("Failed to fetch data"))
                            }
                        )
                    }.catch(errorVariable: "error") {
                        console.error(jsString("Error fetching data:"), jsVarNode("error"))
                        JSStatement(code: "dataDisplay.textContent = `Error: ${error.message}`")
                        jsVar("dataDisplay").setStyle("color", value: "red")
                    }
                })

            jsVar("fetchSection").appendChild(jsVar("fetchBtn"))
            jsVar("fetchSection").appendChild(jsVar("dataDisplay"))

            // While loop demo
            jsConst("whileSection", value: document.createElement("div"))
            jsVar("whileSection").setStyle("marginBottom", value: "20px")

            jsConst("whileTitle", value: document.createElement("h3"))
            jsVar("whileTitle").setTextContent("While Loop Demo")
            jsVar("whileSection").appendChild(jsVar("whileTitle"))

            jsConst("whileList", value: document.createElement("ul"))
            jsLet("counter", value: jsNumber(0))

            jsWhile(jsBinaryOp(jsVarNode("counter"), "<", jsNumber(3))) {
                jsConst("whileItem", value: document.createElement("li"))
                JSStatement(code: "whileItem.textContent = `Iteration ${counter + 1}`")
                jsVar("whileList").appendChild(jsVar("whileItem"))
                jsAssign("counter", value: jsBinaryOp(jsVarNode("counter"), "+", jsNumber(1)))
            }

            jsVar("whileSection").appendChild(jsVar("whileList"))

            // Assemble everything
            jsVar("container").appendChild(jsVar("counterSection"))
            jsVar("container").appendChild(jsVar("listSection"))
            jsVar("container").appendChild(jsVar("switchSection"))
            jsVar("container").appendChild(jsVar("fetchSection"))
            jsVar("container").appendChild(jsVar("whileSection"))

            jsVar("root").appendChild(jsVar("header"))
            jsVar("root").appendChild(jsVar("container"))

            console.log(jsString("App initialized successfully!"))
        }
        + JSProcessor.process {
            JSStatement(code: "document.addEventListener('DOMContentLoaded', initApp);")
        }

    // HTML file content
    let htmlContent = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>JS Processor Demo</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                    background-color: #f5f5f5;
                }

                button {
                    background-color: #007bff;
                    color: white;
                    border: none;
                    border-radius: 5px;
                    font-size: 14px;
                    transition: background-color 0.3s;
                }

                button:hover {
                    background-color: #0056b3;
                }

                ul {
                    list-style-type: disc;
                    padding-left: 20px;
                }
            </style>
        </head>
        <body>
            <div id="root"></div>
            <script>
                // PASTE THE GENERATED JAVASCRIPT HERE
                \(comprehensiveExample)
            </script>
        </body>
        </html>
        """

    return HTTPResponse.html(
        statusCode: 200,
        reason: "OK",
        body: htmlContent
    )
}
