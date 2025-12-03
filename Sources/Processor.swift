#if canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#endif

// MARK: - JS Node Protocol

protocol JSNode {
    func toJS() -> String
}

// MARK: - JS Types

/*
 * Represents a JavaScript statement or expression
 * This is the base building block for all JS code
 */
struct JSStatement: JSNode {
    let code: String

    func toJS() -> String {
        return code
    }
}

/*
 * Represents a JavaScript function declaration
 */
struct JSFunction: JSNode {
    let name: String
    let parameters: Array<String>
    let body: Array<JSNode>
    let returnType: Optional<String>

    func toJS() -> String {
        let params = parameters.joined(separator: ", ")
        let bodyCode = body.map { $0.toJS() }.joined(separator: "\n    ")
        return "function \(name)(\(params)) {\n    \(bodyCode)\n}"
    }
}

/*
 * Represents a JavaScript variable declaration
 */
struct JSVariable: JSNode {
    let name: String
    let value: Optional<JSNode>
    let isConstant: Bool

    func toJS() -> String {
        let keyword = isConstant ? "const" : "let"
        if let val = value {
            return "\(keyword) \(name) = \(val.toJS());"
        }
        return "\(keyword) \(name);"
    }
}

/*
 * Represents a JavaScript if statement
 */
struct JSIf: JSNode {
    let condition: JSNode
    let thenBody: Array<JSNode>
    let elseBody: Optional<Array<JSNode>>

    func toJS() -> String {
        var result = "if (\(condition.toJS())) {\n    "
        result += thenBody.map { $0.toJS() }.joined(separator: "\n    ")
        result += "\n}"

        if let elseStatements = elseBody {
            result += " else {\n    "
            result += elseStatements.map { $0.toJS() }.joined(separator: "\n    ")
            result += "\n}"
        }

        return result
    }
}

/*
 * Represents a JavaScript for loop
 */
struct JSFor: JSNode {
    let variable: String
    let start: JSNode
    let end: JSNode
    let body: Array<JSNode>

    func toJS() -> String {
        var result =
            "for (let \(variable) = \(start.toJS()); \(variable) < \(end.toJS()); \(variable)++) {\n    "
        result += body.map { $0.toJS() }.joined(separator: "\n    ")
        result += "\n}"
        return result
    }
}

/*
 * Represents a JavaScript while loop
 */
struct JSWhile: JSNode {
    let condition: JSNode
    let body: Array<JSNode>

    func toJS() -> String {
        var result = "while (\(condition.toJS())) {\n    "
        result += body.map { $0.toJS() }.joined(separator: "\n    ")
        result += "\n}"
        return result
    }
}

/*
 * Represents a JavaScript return statement
 */
struct JSReturn: JSNode {
    let value: Optional<JSNode>

    func toJS() -> String {
        if let val = value {
            return "return \(val.toJS());"
        }
        return "return;"
    }
}

/*
 * Represents a JavaScript method call
 */
struct JSMethodCall: JSNode {
    let object: Optional<String>
    let method: String
    let arguments: Array<JSNode>

    func toJS() -> String {
        let args = arguments.map { $0.toJS() }.joined(separator: ", ")
        if let obj = object {
            return "\(obj).\(method)(\(args))"
        }
        return "\(method)(\(args))"
    }
}

/*
 * Represents a JavaScript literal value
 */
struct JSLiteral: JSNode {
    let value: String
    let type: JSType

    enum JSType {
        case string
        case number
        case boolean
        case null
        case undefined
    }

    func toJS() -> String {
        switch type {
        case .string:
            return "\"\(value)\""
        case .number, .boolean:
            return value
        case .null:
            return "null"
        case .undefined:
            return "undefined"
        }
    }
}

/*
 * Represents a JavaScript property access
 */
struct JSPropertyAccess: JSNode {
    let object: String
    let property: String

    func toJS() -> String {
        return "\(object).\(property)"
    }
}

/*
 * Represents a JavaScript assignment
 */
struct JSAssignment: JSNode {
    let target: String
    let value: JSNode

    func toJS() -> String {
        return "\(target) = \(value.toJS());"
    }
}

/*
 * Represents a JavaScript binary operation
 */
struct JSBinaryOp: JSNode {
    let left: JSNode
    let operator_: String
    let right: JSNode

    func toJS() -> String {
        return "(\(left.toJS()) \(operator_) \(right.toJS()))"
    }
}

/*
 * Represents a JavaScript switch statement
 */
struct JSSwitch: JSNode {
    let expression: JSNode
    let cases: Array<SwitchCase>
    let defaultCase: Optional<Array<JSNode>>

    struct SwitchCase {
        let value: JSNode
        let body: Array<JSNode>
        let shouldBreak: Bool
    }

    func toJS() -> String {
        var result = "switch (\(expression.toJS())) {\n"

        for case_ in cases {
            result += "    case \(case_.value.toJS()):\n"
            let bodyCode = case_.body.map { "        " + $0.toJS() }.joined(separator: "\n")
            result += bodyCode + "\n"
            if case_.shouldBreak {
                result += "        break;\n"
            }
        }

        if let defaultBody = defaultCase {
            result += "    default:\n"
            let bodyCode = defaultBody.map { "        " + $0.toJS() }.joined(separator: "\n")
            result += bodyCode + "\n"
        }

        result += "}"
        return result
    }
}

/*
 * Represents a JavaScript try-catch-finally block
 */
struct JSTryCatch: JSNode {
    let tryBody: Array<JSNode>
    let catchBody: Optional<CatchBlock>
    let finallyBody: Optional<Array<JSNode>>

    struct CatchBlock {
        let errorVariable: String
        let body: Array<JSNode>
    }

    func toJS() -> String {
        var result = "try {\n    "
        result += tryBody.map { $0.toJS() }.joined(separator: "\n    ")
        result += "\n}"

        if let catch_ = catchBody {
            result += " catch (\(catch_.errorVariable)) {\n    "
            result += catch_.body.map { $0.toJS() }.joined(separator: "\n    ")
            result += "\n}"
        }

        if let finally_ = finallyBody {
            result += " finally {\n    "
            result += finally_.map { $0.toJS() }.joined(separator: "\n    ")
            result += "\n}"
        }

        return result
    }
}

/*
 * Represents a JavaScript throw statement
 */
struct JSThrow: JSNode {
    let error: JSNode

    func toJS() -> String {
        return "throw \(error.toJS());"
    }
}

/*
 * Represents a JavaScript Promise
 */
struct JSPromise: JSNode {
    let expression: String

    func toJS() -> String {
        return expression
    }

    // Then method
    func then(_ callback: JSNode) -> JSPromise {
        return JSPromise(expression: "\(expression).then(\(callback.toJS()))")
    }

    // Catch method
    func `catch`(_ callback: JSNode) -> JSPromise {
        return JSPromise(expression: "\(expression).catch(\(callback.toJS()))")
    }

    // Finally method
    func finally(_ callback: JSNode) -> JSPromise {
        return JSPromise(expression: "\(expression).finally(\(callback.toJS()))")
    }
}

/*
 * Represents a JavaScript async function
 */
struct JSAsyncFunction: JSNode {
    let name: String
    let parameters: Array<String>
    let body: Array<JSNode>

    func toJS() -> String {
        let params = parameters.joined(separator: ", ")
        let bodyCode = body.map { $0.toJS() }.joined(separator: "\n    ")
        return "async function \(name)(\(params)) {\n    \(bodyCode)\n}"
    }
}

/*
 * Represents a JavaScript await expression
 */
struct JSAwait: JSNode {
    let expression: JSNode

    func toJS() -> String {
        return "await \(expression.toJS())"
    }
}

// MARK: - Result Builder

@resultBuilder
struct JSBuilder {
    static func buildBlock(_ components: JSNode...) -> Array<JSNode> {
        return Array(components)
    }

    static func buildOptional(_ component: Array<JSNode>?) -> Array<JSNode> {
        return component ?? []
    }

    static func buildEither(first component: Array<JSNode>) -> Array<JSNode> {
        return component
    }

    static func buildEither(second component: Array<JSNode>) -> Array<JSNode> {
        return component
    }

    static func buildArray(_ components: Array<Array<JSNode>>) -> Array<JSNode> {
        return components.flatMap { $0 }
    }
}

// MARK: - DOM API

/*
 * Represents the JavaScript document object
 * Provides type-safe access to DOM manipulation methods
 */
struct Document {
    // Get element by ID
    func getElementById(_ id: String) -> Element {
        return Element(expression: "document.getElementById(\"\(id)\")")
    }

    // Query selector
    func querySelector(_ selector: String) -> Element {
        return Element(expression: "document.querySelector(\"\(selector)\")")
    }

    // Query selector all
    func querySelectorAll(_ selector: String) -> NodeList {
        return NodeList(expression: "document.querySelectorAll(\"\(selector)\")")
    }

    // Create element
    func createElement(_ tagName: String) -> Element {
        return Element(expression: "document.createElement(\"\(tagName)\")")
    }

    // Create text node
    func createTextNode(_ text: String) -> TextNode {
        return TextNode(expression: "document.createTextNode(\"\(text)\")")
    }
}

/*
 * Represents a DOM element
 * Provides type-safe methods for element manipulation
 */
struct Element: JSNode {
    let expression: String

    func toJS() -> String {
        return expression
    }

    // Append child
    func appendChild(_ child: JSNode) -> JSNode {
        return JSMethodCall(object: expression, method: "appendChild", arguments: [child])
    }

    // Remove child
    func removeChild(_ child: JSNode) -> JSNode {
        return JSMethodCall(object: expression, method: "removeChild", arguments: [child])
    }

    // Add event listener
    func addEventListener(_ event: String, handler: JSNode) -> JSNode {
        return JSMethodCall(
            object: expression,
            method: "addEventListener",
            arguments: [JSLiteral(value: event, type: .string), handler]
        )
    }

    // Remove event listener
    func removeEventListener(_ event: String, handler: JSNode) -> JSNode {
        return JSMethodCall(
            object: expression,
            method: "removeEventListener",
            arguments: [JSLiteral(value: event, type: .string), handler]
        )
    }

    // Set attribute
    func setAttribute(_ name: String, value: String) -> JSNode {
        return JSMethodCall(
            object: expression,
            method: "setAttribute",
            arguments: [
                JSLiteral(value: name, type: .string),
                JSLiteral(value: value, type: .string),
            ]
        )
    }

    // Get attribute
    func getAttribute(_ name: String) -> JSNode {
        return JSMethodCall(
            object: expression,
            method: "getAttribute",
            arguments: [JSLiteral(value: name, type: .string)]
        )
    }

    // Remove attribute
    func removeAttribute(_ name: String) -> JSNode {
        return JSMethodCall(
            object: expression,
            method: "removeAttribute",
            arguments: [JSLiteral(value: name, type: .string)]
        )
    }

    // Set innerHTML
    func setInnerHTML(_ html: String) -> JSNode {
        return JSStatement(code: "\(expression).innerHTML = \"\(html)\";")
    }

    // Set textContent
    func setTextContent(_ text: String) -> JSNode {
        return JSStatement(code: "\(expression).textContent = \"\(text)\";")
    }

    // Add class
    func addClass(_ className: String) -> JSNode {
        return JSMethodCall(
            object: "\(expression).classList",
            method: "add",
            arguments: [JSLiteral(value: className, type: .string)]
        )
    }

    // Remove class
    func removeClass(_ className: String) -> JSNode {
        return JSMethodCall(
            object: "\(expression).classList",
            method: "remove",
            arguments: [JSLiteral(value: className, type: .string)]
        )
    }

    // Toggle class
    func toggleClass(_ className: String) -> JSNode {
        return JSMethodCall(
            object: "\(expression).classList",
            method: "toggle",
            arguments: [JSLiteral(value: className, type: .string)]
        )
    }

    // Set style
    func setStyle(_ property: String, value: String) -> JSNode {
        return JSStatement(code: "\(expression).style.\(property) = \"\(value)\";")
    }
}

/*
 * Represents a NodeList (result of querySelectorAll)
 */
struct NodeList: JSNode {
    let expression: String

    func toJS() -> String {
        return expression
    }

    // ForEach method
    func forEach(_ callback: JSNode) -> JSNode {
        return JSMethodCall(object: expression, method: "forEach", arguments: [callback])
    }
}

/*
 * Represents a text node
 */
struct TextNode: JSNode {
    let expression: String

    func toJS() -> String {
        return expression
    }
}

/*
 * Represents the console object
 */
struct Console {
    func log(_ messages: JSNode...) -> JSNode {
        return JSMethodCall(object: "console", method: "log", arguments: Array(messages))
    }

    func error(_ messages: JSNode...) -> JSNode {
        return JSMethodCall(object: "console", method: "error", arguments: Array(messages))
    }

    func warn(_ messages: JSNode...) -> JSNode {
        return JSMethodCall(object: "console", method: "warn", arguments: Array(messages))
    }

    func info(_ messages: JSNode...) -> JSNode {
        return JSMethodCall(object: "console", method: "info", arguments: Array(messages))
    }
}

/*
 * Represents the Fetch API
 */
struct Fetch {
    /*
     * Performs a fetch request
     */
    func request(_ url: String, options: Optional<FetchOptions> = nil) -> JSPromise {
        if let opts = options {
            let optionsJS = opts.toJS()
            return JSPromise(expression: "fetch(\"\(url)\", \(optionsJS))")
        }
        return JSPromise(expression: "fetch(\"\(url)\")")
    }

    /*
     * Convenience GET request
     */
    func get(_ url: String) -> JSPromise {
        return request(url)
    }

    /*
     * Convenience POST request
     */
    func post(_ url: String, body: String) -> JSPromise {
        let options = FetchOptions(method: "POST", body: body)
        return request(url, options: options)
    }

    /*
     * Convenience PUT request
     */
    func put(_ url: String, body: String) -> JSPromise {
        let options = FetchOptions(method: "PUT", body: body)
        return request(url, options: options)
    }

    /*
     * Convenience DELETE request
     */
    func delete(_ url: String) -> JSPromise {
        let options = FetchOptions(method: "DELETE", body: nil)
        return request(url, options: options)
    }
}

/*
 * Represents fetch request options
 */
struct FetchOptions {
    let method: String
    let body: Optional<String>
    let headers: Optional<Dictionary<String, String>>

    init(
        method: String, body: Optional<String> = nil,
        headers: Optional<Dictionary<String, String>> = nil
    ) {
        self.method = method
        self.body = body
        self.headers = headers
    }

    func toJS() -> String {
        var options: Array<String> = []
        options.append("method: \"\(method)\"")

        if let b = body {
            options.append("body: \"\(b)\"")
        }

        if let h = headers {
            let headerPairs = h.map { key, value in
                return "\"\(key)\": \"\(value)\""
            }.joined(separator: ", ")
            options.append("headers: { \(headerPairs) }")
        }

        return "{ " + options.joined(separator: ", ") + " }"
    }
}

/*
 * Represents a Response object from fetch
 */
struct Response: JSNode {
    let expression: String

    func toJS() -> String {
        return expression
    }

    // Parse as JSON
    func json() -> JSPromise {
        return JSPromise(expression: "\(expression).json()")
    }

    // Parse as text
    func text() -> JSPromise {
        return JSPromise(expression: "\(expression).text()")
    }

    // Check if response is ok
    func ok() -> JSNode {
        return JSStatement(code: "\(expression).ok")
    }

    // Get status code
    func status() -> JSNode {
        return JSStatement(code: "\(expression).status")
    }
}

// MARK: - Global Objects

let document = Document()
let console = Console()
let fetch = Fetch()

// MARK: - Helper Functions

/*
 * Creates a JavaScript string literal
 */
func jsString(_ value: String) -> JSNode {
    return JSLiteral(value: value, type: .string)
}

/*
 * Creates a JavaScript number literal
 */
func jsNumber(_ value: Int) -> JSNode {
    return JSLiteral(value: String(value), type: .number)
}

/*
 * Creates a JavaScript boolean literal
 */
func jsBool(_ value: Bool) -> JSNode {
    return JSLiteral(value: value ? "true" : "false", type: .boolean)
}

/*
 * Creates a JavaScript null literal
 */
func jsNull() -> JSNode {
    return JSLiteral(value: "", type: .null)
}

/*
 * Creates a JavaScript undefined literal
 */
func jsUndefined() -> JSNode {
    return JSLiteral(value: "", type: .undefined)
}

/*
 * Creates a JavaScript variable reference as an Element
 * Use this when you need to call DOM methods on a variable
 */
func jsVar(_ name: String) -> Element {
    return Element(expression: name)
}

/*
 * Creates a JavaScript variable reference as a generic JSNode
 * Use this for non-DOM variables
 */
func jsVarNode(_ name: String) -> JSNode {
    return JSStatement(code: name)
}

/*
 * Creates a JavaScript arrow function
 */
func jsArrowFunction(parameters: Array<String>, @JSBuilder body: () -> Array<JSNode>) -> JSNode {
    let params = parameters.joined(separator: ", ")
    let bodyCode = body().map { $0.toJS() }.joined(separator: "\n    ")
    return JSStatement(code: "(\(params)) => {\n    \(bodyCode)\n}")
}

/*
 * Creates a JavaScript if statement
 */
func jsIf(_ condition: JSNode, @JSBuilder then thenBody: () -> Array<JSNode>) -> JSNode {
    return JSIf(condition: condition, thenBody: thenBody(), elseBody: nil)
}

/*
 * Creates a JavaScript if-else statement
 */
func jsIfElse(
    _ condition: JSNode, @JSBuilder then thenBody: () -> Array<JSNode>,
    @JSBuilder else elseBody: () -> Array<JSNode>
) -> JSNode {
    return JSIf(condition: condition, thenBody: thenBody(), elseBody: elseBody())
}

/*
 * Creates a JavaScript for loop
 */
func jsFor(variable: String, from start: Int, to end: Int, @JSBuilder body: () -> Array<JSNode>)
    -> JSNode
{
    return JSFor(
        variable: variable,
        start: jsNumber(start),
        end: jsNumber(end),
        body: body()
    )
}

/*
 * Creates a JavaScript while loop
 */
func jsWhile(_ condition: JSNode, @JSBuilder body: () -> Array<JSNode>) -> JSNode {
    return JSWhile(condition: condition, body: body())
}

/*
 * Creates a JavaScript return statement
 */
func jsReturn(_ value: Optional<JSNode> = nil) -> JSNode {
    return JSReturn(value: value)
}

/*
 * Creates a JavaScript variable declaration (let)
 */
func jsLet(_ name: String, value: Optional<JSNode> = nil) -> JSNode {
    return JSVariable(name: name, value: value, isConstant: false)
}

/*
 * Creates a JavaScript constant declaration (const)
 */
func jsConst(_ name: String, value: JSNode) -> JSNode {
    return JSVariable(name: name, value: value, isConstant: true)
}

/*
 * Creates a JavaScript assignment
 */
func jsAssign(_ target: String, value: JSNode) -> JSNode {
    return JSAssignment(target: target, value: value)
}

/*
 * Creates a JavaScript binary operation
 */
func jsBinaryOp(_ left: JSNode, _ operator_: String, _ right: JSNode) -> JSNode {
    return JSBinaryOp(left: left, operator_: operator_, right: right)
}

/*
 * Creates a JavaScript switch statement
 */
func jsSwitch(
    _ expression: JSNode, cases: Array<JSSwitch.SwitchCase>,
    default defaultCase: Optional<Array<JSNode>> = nil
) -> JSNode {
    return JSSwitch(expression: expression, cases: cases, defaultCase: defaultCase)
}

/*
 * Creates a switch case
 */
func jsSwitchCase(_ value: JSNode, @JSBuilder body: () -> Array<JSNode>, shouldBreak: Bool = true)
    -> JSSwitch.SwitchCase
{
    return JSSwitch.SwitchCase(value: value, body: body(), shouldBreak: shouldBreak)
}

/*
 * Creates a JavaScript try-catch block
 */
func jsTry(@JSBuilder _ tryBody: () -> Array<JSNode>) -> JSTryCatch {
    return JSTryCatch(tryBody: tryBody(), catchBody: nil, finallyBody: nil)
}

/*
 * Adds a catch block to a try statement
 */
extension JSTryCatch {
    func `catch`(errorVariable: String = "error", @JSBuilder _ catchBody: () -> Array<JSNode>)
        -> JSTryCatch
    {
        return JSTryCatch(
            tryBody: self.tryBody,
            catchBody: CatchBlock(errorVariable: errorVariable, body: catchBody()),
            finallyBody: self.finallyBody
        )
    }

    func finally(@JSBuilder _ finallyBody: () -> Array<JSNode>) -> JSTryCatch {
        return JSTryCatch(
            tryBody: self.tryBody,
            catchBody: self.catchBody,
            finallyBody: finallyBody()
        )
    }
}

/*
 * Creates a JavaScript throw statement
 */
func jsThrow(_ error: JSNode) -> JSNode {
    return JSThrow(error: error)
}

/*
 * Creates a JavaScript new Error
 */
func jsError(_ message: String) -> JSNode {
    return JSStatement(code: "new Error(\"\(message)\")")
}

/*
 * Creates a JavaScript async function
 */
func jsAsyncFunction(parameters: Array<String>, @JSBuilder body: () -> Array<JSNode>) -> JSNode {
    let params = parameters.joined(separator: ", ")
    let bodyCode = body().map { $0.toJS() }.joined(separator: "\n    ")
    return JSStatement(code: "async (\(params)) => {\n    \(bodyCode)\n}")
}

/*
 * Creates a JavaScript await expression
 */
func jsAwait(_ expression: JSNode) -> JSNode {
    return JSAwait(expression: expression)
}

/*
 * Creates a Response object reference
 */
func jsResponse(_ varName: String) -> Response {
    return Response(expression: varName)
}

// MARK: - JS Processor

/*
 * Main processor that converts Swift code blocks to JavaScript
 */
struct JSProcessor {
    /*
     * Creates a JavaScript function from a Swift closure
     */
    static func createFunction(
        name: String,
        parameters: Array<String> = [],
        @JSBuilder body: () -> Array<JSNode>
    ) -> String {
        let function = JSFunction(
            name: name,
            parameters: parameters,
            body: body(),
            returnType: nil
        )
        return function.toJS()
    }

    /*
     * Creates a JavaScript async function from a Swift closure
     */
    static func createAsyncFunction(
        name: String,
        parameters: Array<String> = [],
        @JSBuilder body: () -> Array<JSNode>
    ) -> String {
        let function = JSAsyncFunction(
            name: name,
            parameters: parameters,
            body: body()
        )
        return function.toJS()
    }

    /*
     * Processes a block of JS nodes and returns the JavaScript code
     */
    static func process(@JSBuilder _ content: () -> Array<JSNode>) -> String {
        let nodes = content()
        return nodes.map { $0.toJS() }.joined(separator: "\n")
    }
}

// MARK: - Example Usage

/*
 * Comprehensive example demonstrating all features:
 * - DOM manipulation
 * - Event handlers
 * - Control flow (if/else, for, while, switch)
 * - Try/catch error handling
 * - Fetch API with async/await
 * - Styling and class manipulation
 */
